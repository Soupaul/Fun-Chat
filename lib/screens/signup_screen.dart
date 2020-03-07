import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:fun_chat/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  static final String id = 'signup_screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password, _profileImageUrl;
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future uploadPic(BuildContext context) async {
    setState(() {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Uploading Profile Picture'),
        ),
      );
    });
    String fileName = path.basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    /*StorageTaskSnapshot taskSnapshot*/
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    _profileImageUrl = downUrl.toString();
  }

  _submit() {
    if (_formKey.currentState.validate()) _formKey.currentState.save();
    //Signing up user with firebase
    AuthService.signUpUser(context, _name, _email, _password, _profileImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(
        "images/doodle_background2.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Fun Chat',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontFamily: 'ShadowsIntoLight',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Icon(
                        Icons.chat,
                        color: Colors.green,
                        size: 50.0,
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 30.0),
                      CircleAvatar(
                        radius: 75.0,
                        backgroundColor: Colors.lightBlue,
                        child: ClipOval(
                          child: SizedBox(
                            width: 130.0,
                            height: 130.0,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    'https://thebenclark.files.wordpress.com/2014/03/facebook-default-no-profile-pic.jpg?w=1200',
                                    fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.lightBlue),
                        onPressed: getImage,
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.blue,
                      onPressed: () => uploadPic(context),
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                            validator: (input) => input.isEmpty
                                ? 'Please enter a valid name'
                                : null,
                            onSaved: (input) => _name = input,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (input) => !input.contains('@')
                                ? 'Please enter a valid email address'
                                : null,
                            onSaved: (input) => _email = input,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            validator: (input) => input.length < 8
                                ? 'Must have atleast 8 characters'
                                : null,
                            onSaved: (input) => _password = input,
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          width: 250.0,
                          child: FlatButton(
                            padding: EdgeInsets.all(10.0),
                            color: Colors.blue,
                            onPressed: _submit,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: 250.0,
                          child: FlatButton(
                            padding: EdgeInsets.all(10.0),
                            color: Colors.blue,
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Back to Login',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ]);
  }
}
