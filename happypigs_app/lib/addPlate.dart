import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happypigs_app/file.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPlatePage extends StatefulWidget {
  @override
  _AddPlatePageState createState() => _AddPlatePageState();
}

class _AddPlatePageState extends State<AddPlatePage> {
  List<FileModel> files = [];
  FileModel selectedModel = FileModel([], "");
  File image;

  String _error = 'No error detected';

  @override
  void initState() {
    super.initState();
    getImagesPath();
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

  // Widget buildSliderView(contextSize) {
  //   return CarouselSlider(
  //       items: images.map(
  //               (item) => Container(
  //                 width: 300,
  //                 height: 300,
  //                 child: AssetThumb(
  //                   asset: item,
  //                   width: 300,
  //                   height: 300,
  //                 ),
  // decoration: new BoxDecoration(
  //   shape: BoxShape.circle,
  //   border: Border.all(color: Colors.pinkAccent),
  //   image: DecorationImage(image: AssetImage(item), fit:BoxFit.fill,),
  // ),
  //               )
  //       ).toList(),
  //       options: CarouselOptions(autoPlay: false),
  //   );
  // }

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
    var contextSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: new Text('What did you eat?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.pink.shade50, fontFamily: 'Oi')),
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.4,
              child: image != null
                  ? Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.45,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                  Border.all(color: Colors.pink.shade50, width: 10),
                  image: DecorationImage(
                      image: FileImage(image), fit: BoxFit.fill),
                ),
              )
                  : Container(child: Center(
                child: new SizedBox(
                  height: 50,
                  width: 50,
                  child: new CircularProgressIndicator(),),
              ),),
            ),
            Divider(),
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.38,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4),
                  itemBuilder: (_, i) {
                    var file = selectedModel.files[i];
                    return GestureDetector(
                      child: Image.file(
                        file,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        setState(() {
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
          .map((e) =>
          DropdownMenuItem(
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
