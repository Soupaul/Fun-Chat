import 'package:flutter/material.dart';
import 'package:fun_chat/screens/signup_screen.dart';
import 'package:fun_chat/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  _submit() {
    if (_formKey.currentState.validate()) _formKey.currentState.save();
    //Login the user w/ Firebase
    AuthService.login(_email, _password);
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 85.0),
                      child: Row(
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
                    ),
                  ],
                ),
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
                            'Login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
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
                          onPressed: () =>
                              Navigator.pushNamed(context, SignUpScreen.id),
                          child: Text(
                            'Go to Sign Up',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
