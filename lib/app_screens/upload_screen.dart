import 'dart:io';
import 'package:blog_app/app_screens/home_screen.dart';
import 'package:blog_app/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  final TextEditingController _descriptionEditingController = TextEditingController();

  File _imageFile;

  bool _loading = false;

  ImagePicker imagePicker = ImagePicker();

  Future<void> _chooseImage() async{
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile  = File(pickedFile.path);
    });
  }

  void _validate()  {
    if(_imageFile == null && _descriptionEditingController.text.isEmpty){
      Fluttertoast.showToast(
          msg: 'Please add image and enter description',
          backgroundColor: Colors.redAccent
      );
    }
    else if(_imageFile == null){
      Fluttertoast.showToast(
          msg: 'Please add image',
          backgroundColor: Colors.redAccent
      );
    }
    else if(_descriptionEditingController.text.isEmpty){
      Fluttertoast.showToast(
        msg: 'Please enter description ',
          backgroundColor: Colors.redAccent
      );
    }
    else{
      setState(() {
        _loading  = true;
      });
      _uploadImage();
    }
  }

  void _uploadImage()  {
    //Create a unique file name for image
    String imageFileName  = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageReference  = FirebaseStorage.instance.ref().child('Images').child(imageFileName);

    final UploadTask uploadTask = storageReference.putFile(_imageFile);

    uploadTask.then((TaskSnapshot taskSnapshot){
      taskSnapshot.ref.getDownloadURL().then((imageUrl){
        //Save the info to firestore
        _saveData(imageUrl);
      });
    }).catchError((error){
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: error.toString(),
          backgroundColor: Colors.redAccent
      );
    });
  }

  void _saveData(String imageUrl) {

    var dateFormat  = DateFormat('MMM d, yyyy');
    var timeFormat  = DateFormat('EEEE, hh:mm a');

    String date = dateFormat.format(DateTime.now()).toString();
    String time = timeFormat.format(DateTime.now()).toString();
    

    FirebaseFirestore.instance.collection('posts').add({
      'imageUrl'  : imageUrl,
      'description' : _descriptionEditingController.text,
      'date'  : date,
      'time'  : time,
    }).whenComplete((){
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: 'Post added successfully',
          backgroundColor: Colors.redAccent
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
        return HomeScreen();
      }));
    }).catchError((error){
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: error.toString(),
          backgroundColor: Colors.redAccent
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
        _imageFile == null ? Container(
              width: double.infinity,
              height: 250.0,
              color: Colors.grey,
              child: Center(
                child: RaisedButton(
                  onPressed: () {
                    _chooseImage();
                  },
                  color: Colors.pink,
                  child: Text(
                    'Choose Image',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ): GestureDetector(
          onTap: () {
            _chooseImage();
          },
          child: Container(
          width: double.infinity,
          height: 250.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(_imageFile),
                fit: BoxFit.cover,
              ),
          ),
        ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
            SizedBox(height: 35.0),
            _loading ?  circularProgress() : GestureDetector(
              onTap: _validate,
              child: Container(
                color: Colors.pink,
                width: double.infinity,
                height: 50.0,
                child: Center(
                  child: Text(
                    'Add New Post',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
