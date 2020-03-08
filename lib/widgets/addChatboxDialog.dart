import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDialog {
  TextEditingController _textFieldController = TextEditingController();
  final _firestore = Firestore.instance;

  displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFF263238),
            title: Text(
              'New Chatbox',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Type name of Chatbox"),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  'OK',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  _firestore.collection('chatbox').add({
                    'name': _textFieldController.text,
                  });
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  AddDialog(BuildContext context) {
    displayDialog(context);
  }
}
