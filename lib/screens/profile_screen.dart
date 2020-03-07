import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  static final String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Stream<DocumentSnapshot> getStream() async* {
    final uid = await AuthService.getCurrentUID();
    yield* Firestore.instance.collection('users').document(uid).snapshots();
  }

  Widget _buildScreen() {
    Widget widget = StreamBuilder(
      stream: getStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot data = snapshot.data;
          return Column(
            children: <Widget>[
              SizedBox(height: 35.0),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1),
                          CircleAvatar(
                            radius: 75.0,
                            backgroundImage:
                                NetworkImage(data['profileImageUrl']),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.lightBlue),
                          )
                        ],
                      ),
                      SizedBox(height: 50.0),
                      Row(
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2),
                          Text(
                            'Name : ',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            data['name'],
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.lightBlue),
                            onPressed: () {
                              Firestore.instance
                                  .runTransaction((transaction) async {
                                DocumentSnapshot freshDoc =
                                    await transaction.get(data.reference);
                                await transaction.update(freshDoc.reference,
                                    {'name': freshDoc['name']});
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2),
                          Text(
                            'Email : ',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            data['email'],
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Center(
              child: Text(
            'Loading...',
            style: TextStyle(color: Colors.white),
          ));
        }
      },
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Color(0xFF263238)),
        ),
      ),
      body: _buildScreen(),
    );
  }
}
