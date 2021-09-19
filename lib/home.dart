import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();


  @override
  void initState() {
    loadModel().then((value){
      setState(() {

      });
    });
  }

  detectImage(File image) async{
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5
    );

    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async{
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt'
    );
  }

  pickImage() async{
    var image = await picker.getImage(source: ImageSource.camera);
    if(image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  selectImage() async{
    var image = await picker.getImage(source: ImageSource.gallery);
    if(image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Text(
                'Cat and Dog',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),
            SizedBox(height: 5,),
              Text(
                'Detector',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                ),
              ),
            SizedBox(height: 40,),
            Center(
              child: _loading ? Container(
                width: 350,
                child: Column(
                  children: [
                    Image.asset('assets/cd.png'),
                  ],
                ),
              ) : Container(
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      child: Image.file(_image),
                    ),
                    SizedBox(height: 20,),
                    _output != null ?
                    Text(
                        '${_output[0]['label']}',
                      style: TextStyle(
                          color: Colors.white,
                        fontSize: 15
                      ),
                    ) :
                    Container(),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 18
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: Text(
                          'Capture a Photo',
                        style: TextStyle(
                          color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      selectImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 18
                      ),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: Text(
                        'Select a Photo',
                        style: TextStyle(
                            color: Colors.white,
                          fontSize: 16
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
