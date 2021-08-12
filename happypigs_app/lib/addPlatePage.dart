import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:happypigs_app/file.dart';
import 'package:happypigs_app/util.dart';
import 'package:happypigs_app/db/Plate.dart';
import 'package:exif/exif.dart';
import 'package:intl/intl.dart';

class AddPlatePage extends StatefulWidget {
  @override
  _AddPlatePageState createState() => _AddPlatePageState();
}

class _AddPlatePageState extends State<AddPlatePage> {
  List<FileModel> files = [];
  FileModel selectedModel = FileModel([], "");
  File image;
  PhotoViewScaleStateController scaleStateController;
  var photoController;
  PhotoViewControllerValue photoSetting;
  var dateTime = DateTime.now();
  Map<String, dynamic> location = {};

  String _error = 'No error detected';

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    photoController = PhotoViewController()..outputStateStream.listen(listener);
    getImagesPath();
  }

  @override
  void dispose() {
    scaleStateController.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue value) {
    setState(() {
      photoSetting = value;
      logger.d(
          'DEBUG : photo is changed : position: ${photoSetting.position} / rotation: ${photoSetting.rotation} / rotationfocuspoint: ${photoSetting.rotationFocusPoint} / scale: ${photoSetting.scale} ');
    });
  }

  void goResizeBack() {
    scaleStateController.scaleState = PhotoViewScaleState.covering;
  }

  void getImagesPath() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> list =
          await PhotoManager.getAssetPathList(type: RequestType.image);
      logger.d("$list");
      for (int i = 0; i < list.length; i++) {
        var assetEntity = list[i];
        var assets = await assetEntity.assetList;
        var imageList = [];
        for (int j = 0; j < assets.length; j++) {
          var path = await assets[j].file;
          imageList.add(path);
        }
        files.add(FileModel(imageList, assetEntity.name));
      }
    } else {
      _error = "No permission there.";
      logger.e(_error);
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
        title: Align(
          alignment: Alignment.center,
          child: Container(
            child: Text('What did you eat?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.pink.shade50,
                    fontFamily: 'Oi',
                    fontSize: 16.0)),
          ),
        ),
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
            onPressed: () async {
              await _getDatafromImage();
              Plate newPlate = Plate(
                  imgPaths: [image.path],
                  foodImage: Utility.base64String(image.readAsBytesSync()),
                  foodSetting: photoSetting,
                  whereToEat:
                      location == {} ? "Need to fill" : location.toString(),
                  whenToEat: dateTime,
                  description: "",
                  tag_ids: [],
                  rating: 1,
                  plateTypeId: 0);
              Navigator.of(context).pushNamed('/addScore', arguments: newPlate);
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
                                    loadingBuilder: (context, progress) =>
                                        Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.pink.shade50),
                                    ),
                                    enableRotation: true,
                                    minScale:
                                        PhotoViewComputedScale.contained * 0.8,
                                    maxScale:
                                        PhotoViewComputedScale.covered * 2,
                                    initialScale:
                                        PhotoViewComputedScale.covered,
                                    basePosition: Alignment.center,
                                    controller: photoController,
                                    scaleStateController: scaleStateController,
                                    backgroundDecoration:
                                        BoxDecoration(color: Colors.white),
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
                    child: IconButton(
                        onPressed: goResizeBack,
                        icon: Icon(
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
                              opacity: image == file ? 0.5 : 1.0,
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
    logger.e("ERROR : There is no files");
    return [];
  }

  void _getDatafromImage() async {
    Map<String, IfdTag> imgTags =
        await readExifFromBytes(File(image.path).readAsBytesSync());
    print(imgTags);

    if (imgTags.containsKey('Image DateTime')) {
      dateTime = DateFormat("yyyy:MM:dd HH:mm:ss").parse(imgTags['Image DateTime'].toString());
    }

    if (imgTags.containsKey('GPS GPSLongitude')) {
      get_exifGPS(imgTags);
    }
  }

  void get_exifGPS(Map<String, IfdTag> tags) {
    final latitudeValue = tags['GPS GPSLatitude']
        .values
        .map<double>(
            (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final latitudeSignal = tags['GPS GPSLatitudeRef'].printable;

    final longitudeValue = tags['GPS GPSLongitude']
        .values
        .map<double>(
            (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
        .toList();
    final longitudeSignal = tags['GPS GPSLongitudeRef'].printable;

    double latitude =
        latitudeValue[0] + (latitudeValue[1] / 60) + (latitudeValue[2] / 3600);

    double longitude = longitudeValue[0] +
        (longitudeValue[1] / 60) +
        (longitudeValue[2] / 3600);

    if (latitudeSignal == 'S') latitude = -latitude;
    if (longitudeSignal == 'W') longitude = -longitude;

    location['latitude'] = latitude;
    location['longitude'] = longitude;
  }
}
