import 'dart:ui';
import 'dart:io';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool is_loading = true;
  String disease = "";
  String accuracy = "";
  late File _image;
  late List _output;
  final picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    load_model();
  }

  ditect_Image(File image)async{
    var output = await Tflite.runModelOnImage(path: image.path,numResults: 2,imageMean: 0.0,imageStd: 1.0,asynch: true);
    setState(() {
      _output=output!;
      is_loading = false;
      disease = _output[0]['label'];
      accuracy = 'accuracy:'+ (_output[0]['confidence']*100).toString();
    });
    print("Model Output: $_output");
  }
  load_model()async{
    await Tflite.loadModel(model: 'assets/model.tflite',labels: 'assets/labels.txt');
  }
  @override
  void dispose(){
    super.dispose();
  }

  pick_image()async{
    var image = await picker.getImage(source: ImageSource.camera);
    if(image==null){
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    ditect_Image(_image);
  }

  pick_gallary_image()async{
    var image = await picker.getImage(source: ImageSource.gallery);
    if(image==null){
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    ditect_Image(_image);
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/ZSnk7J.jpg'),
            fit: BoxFit.cover,
          )
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              height: 640.0,
              width: 316,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
              ),
              child: Stack(
                children: [
                  //Blur Effect
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(),
                  ),
                  //Gradient Effect
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.20)),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ]),
                    ),
                  ),
                  //Child
                 Center(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       is_loading?Container(
                         width: 224,
                         height: 244,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(8)),
                           color: Colors.white.withOpacity(0.9),
                           image: DecorationImage(
                             image: AssetImage('assets/leaf.png'),
                           ),
                         ),
                       ):Container(
                         width: 224,
                         height: 244,
                         child: Image.file(_image),
                       ),
                       SizedBox(
                         height: 16,
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.white70,
                             ),
                             onPressed: (){
                               pick_image();
                             },
                             child: Text('Use camera ',style: TextStyle(color: Colors.black),)
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.white70,
                             ),
                             onPressed: (){
                               pick_gallary_image();
                             },
                             child: Text('Pick image from gallary',style: TextStyle(color: Colors.black),)
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(disease,style: TextStyle(
                           color: Colors.white,
                         ),),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(accuracy,style: TextStyle(
                           color: Colors.white,
                         ),),
                       )
                     ],
                   ),
                 ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
/*
* child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            is_loading?Container(
              width: 180,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ):Container(),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: (){},
                  child: Text('Use camera to click image',style: TextStyle(color: Colors.black),)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: (){},
                  child: Text('Pick image from gallary',style: TextStyle(color: Colors.black),)
              ),
            )
          ],
        ),
* */