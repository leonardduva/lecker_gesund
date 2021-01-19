import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lecker_gesund/services/database_service.dart';
import 'package:uuid/uuid.dart';
import 'package:lecker_gesund/services/upload_image.dart';
import 'package:lecker_gesund/utils/constants.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DatabaseService databaseService = DatabaseService();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController peopleController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _uploadImage = UploadImage();

  File _image;
  bool isUploading = false;
  // generate recipe id
  String recipeId = Uuid().v4();
  String downloadUrl;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
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
            ),
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
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text('Upload Image'),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    child: Text('Image fro Camera'),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      _image =
                                          await _uploadImage.getImageCamera();
                                      setState(() {
                                        this._image = _image;
                                      });
                                    },
                                  ),
                                  SimpleDialogOption(
                                    child: Text('Image fro Gallery'),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      _image =
                                          await _uploadImage.getImageGallery();

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
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .4,
                          child: TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: "Title:",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: MediaQuery.of(context).size.width * .2,
                          child: TextFormField(
                            controller: timeController,
                            decoration: InputDecoration(
                              hintText: "Time:",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter time';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .2,
                          child: TextFormField(
                            controller: peopleController,
                            decoration: InputDecoration(
                              hintText: "People:",
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter people';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextFormField(
                        controller: ingredientsController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Ingredients',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText:
                              "Seperate each by comma: 1 egg, 2 tomatoes, etc.",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter ingredients';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Directions',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText:
                              "Seperate each step by a comma: chop onions, boil eggs, etc.",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter directions';
                          }
                          return null;
                        },
                      ),
                    )
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
                    downloadUrl =
                        await _uploadImage.uploadImageToFirebase(_image);
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
              },
            )
          ],
        ),
      ),
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
