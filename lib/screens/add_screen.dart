import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/services/database_service.dart';
import 'package:lecker_gesund/widgets/input_field.dart';
import 'package:uuid/uuid.dart';
import 'package:lecker_gesund/services/upload_image.dart';
import 'package:lecker_gesund/utils/constants.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uploadImage = UploadImage();
  final DatabaseService databaseService = DatabaseService();

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController peopleController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File _image;
  bool isUploading = false;
  String recipeId = Uuid().v4();
  String downloadUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildUploadHeader(context),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: CircleAvatar(
                          backgroundImage: _image != null
                              ? Image.file(_image, fit: BoxFit.cover).image
                              : null,
                          backgroundColor: Colors.black12,
                          radius: 60,
                          child: _image == null
                              ? Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(''),
                        ),
                        onTap: () async {
                          await _buildShowDialog(context);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InputField(
                          width: MediaQuery.of(context).size.width * .4,
                          controller: titleController,
                          hintText: 'Title',
                          validationText: 'Enter title',
                        ),
                        SizedBox(width: 10),
                        InputField(
                          width: MediaQuery.of(context).size.width * .2,
                          controller: timeController,
                          hintText: 'Time',
                          validationText: 'Enter time',
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        InputField(
                          width: MediaQuery.of(context).size.width * .2,
                          validationText: 'Enter people',
                          controller: peopleController,
                          hintText: 'People',
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    InputField(
                      controller: ingredientsController,
                      labelText: 'Ingredients',
                      maxLines: 2,
                      hintText:
                          'Seperate each by comma: 1 egg, 2 tomatoes, etc.',
                      validationText: 'Enter ingredients',
                    ),
                    SizedBox(height: 20),
                    InputField(
                      controller: descriptionController,
                      labelText: 'Directions',
                      maxLines: 3,
                      hintText:
                          "Seperate each step by a comma: chop onions, boil eggs, etc.",
                      validationText: 'Please enter directions',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              child: isUploading
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    )
                  : Text(
                      'Create',
                    ),
              color: Theme.of(context).accentColor,
              textColor: Colors.black,
              onPressed: () async {
                await handleCreate(isUploading);
              },
            )
          ],
        ),
      ),
    );
  }

  handleCreate(bool isUploading) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isUploading = true;
      });
      //link placeholder image if user doesn't choose one
      if (_image == null) {
        downloadUrl = foodPlaceholderImage;
      } else if (_image != null) {
        //compress Image
        _image = await _uploadImage.compressImage(_image);
        //get download link
        downloadUrl = await _uploadImage.uploadImageToFirebase(_image);
      }
      //create recipe in firebase
      databaseService.addRecipe(
        title: titleController.text,
        time: timeController.text,
        people: peopleController.text,
        ingredients: ingredientsController.text,
        description: descriptionController.text,
        recipeId: recipeId,
        imageUrl: downloadUrl,
        onSuccess: () {
          print('object created');
          setState(() {
            isUploading = false;
          });
        },
      );
      Navigator.pop(context);
    }
  }

  Container _buildUploadHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      color: Colors.black12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Your Recipe',
            style: TextStyle(fontSize: 25, color: Colors.black),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  _buildShowDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Upload Image'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Image from Camera'),
              onPressed: () async {
                Navigator.pop(context);
                _image = await _uploadImage.getImageCamera();
                setState(() {
                  this._image = _image;
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Image from Gallery'),
              onPressed: () async {
                Navigator.pop(context);
                _image = await _uploadImage.getImageGallery();

                setState(() {
                  this._image = _image;
                });
              },
            ),
            SimpleDialogOption(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    timeController.dispose();
    peopleController.dispose();
    ingredientsController.dispose();
    descriptionController.dispose();
  }
}
