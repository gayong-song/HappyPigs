import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happypigs_app/file.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

class AddPlatePage extends StatefulWidget {
  @override
  _AddPlatePageState createState() => _AddPlatePageState();
}

class _AddPlatePageState extends State<AddPlatePage> {
  List<FileModel> files = [];
  FileModel selectedModel = FileModel([], "");
  File image;
  PhotoViewScaleStateController scaleStateController;

  String _error = 'No error detected';

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    getImagesPath();
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  void goResizeBack() {
    scaleStateController.scaleState = PhotoViewScaleState.originalSize;
  }

  void getImagesPath() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> list =
          await PhotoManager.getAssetPathList(type: RequestType.image);
      print("DEBUG : $list");
      for (int i = 0; i < list.length; i++) {
        var assetEntity = list[i];
        var assets = await assetEntity.assetList;
        var imageList = [];
        for (int j = 0; j < assets.length; j++) {
          var path = await assets[j].file;
          print("DEBUG : $path");
          imageList.add(path);
        }
        files.add(FileModel(imageList, assetEntity.name));
      }
    } else {
      _error = "No permission there.";
      print(_error);
    }

    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
      });
  }

  // _getFromCamera(contextSize) async {
  //   PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.camera, maxWidth: contextSize.width, maxHeight: contextSize.height,);
  //   if( pickedFile != null ){
  //     setState(() {
  //       File imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var contextSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: new Text('What did you eat?',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.pink.shade50, fontFamily: 'Oi', fontSize: 16.0)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.pink.shade50,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.navigate_next),
            color: Colors.pink.shade50,
            onPressed: () {
              Navigator.of(context).pushNamed('/addScore');
            },
          ),
        ],
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: contextSize.height * 0.4,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: image != null
                        ? Container(
                            height: contextSize.height * 0.4,
                            width: contextSize.height * 0.4,
                            alignment: Alignment.center,
                            child: Stack(
                              children: <Widget>[
                                ClipOval(
                                  child: PhotoView(
                                    imageProvider: FileImage(image),
                                    enableRotation: true,
                                    minScale:
                                        PhotoViewComputedScale.contained * 0.8,
                                    maxScale:
                                        PhotoViewComputedScale.covered * 1.2,
                                    initialScale: contextSize.height * 0.4,
                                    scaleStateController: scaleStateController,
                                    backgroundDecoration: BoxDecoration(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.pink.shade50, width: 10),
                            ),
                          )
                        : Container(
                            child: Center(
                              child: new SizedBox(
                                height: 50,
                                width: 50,
                                child: new CircularProgressIndicator(),
                              ),
                            ),
                          ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: goResizeBack,
                        child: Icon(
                          Icons.settings_backup_restore,
                          color: Colors.pink.shade50,
                        )),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white),
            Container(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                  items: getItems(),
                  style: TextStyle(color: Colors.pink.shade50),
                  onChanged: (dynamic d) {
                    assert(d.files.length > 0);
                    image = d.files[0];
                    setState(() {
                      selectedModel = d;
                    });
                  },
                  value: selectedModel,
                )),
              ),
            ),
            selectedModel == null && selectedModel.files.length < 1
                ? Container()
                : Container(
                    height: contextSize.height * 0.38,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4),
                        itemBuilder: (_, i) {
                          var file = selectedModel.files[i];
                          return GestureDetector(
                            child: Opacity(
                              opacity: image==file?0.5:1.0,
                              child: Image.file(
                                file,
                                fit: BoxFit.cover,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                goResizeBack();
                                image = file;
                              });
                            },
                          );
                        },
                        itemCount: selectedModel.files.length),
                  )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> getItems() {
    if (files != null && files.length > 0)
      return files
              .map((e) => DropdownMenuItem(
                    child: Text(
                      e.folder,
                      style: TextStyle(color: Colors.black),
                    ),
                    value: e,
                  ))
              .toList() ??
          [];
    print("ERROR : There is no files");
    return [];
  }
}
