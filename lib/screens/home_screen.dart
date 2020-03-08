import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat/models/message_model.dart';
import 'package:fun_chat/screens/profile_screen.dart';
import 'package:fun_chat/services/auth_service.dart';
import 'package:fun_chat/widgets/favourite_contacts.dart';
import 'package:fun_chat/widgets/category_selector.dart';
import 'package:fun_chat/widgets/recent_chats.dart';
import 'package:fun_chat/widgets/addChatboxDialog.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final choices = ['Search', 'Log Out'];
  final _firestore = Firestore.instance;

  Stream<DocumentSnapshot> getStream() async* {
    final uid = await AuthService.getCurrentUID();
    yield* _firestore.collection('users').document(uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 5.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, ProfileScreen.id),
            child: StreamBuilder(
                stream: getStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    DocumentSnapshot ds = snapshot.data;
                    return CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(ds['profileImageUrl']),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ),
        ),

        /*IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Color(0xFF263238),
          onPressed: () {},
        ),*/
        title: Center(
            child: Text(
          'Fun Chat',
          style: TextStyle(
              fontSize: 30.0,
              fontFamily: 'ShadowsIntoLight',
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238)),
        )),
        elevation: 0.0,
        actions: <Widget>[
          /*IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),*/
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Color(0xFF263238),
            ),
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: GestureDetector(
                      onTap: () => _performAction(choice), child: Text(choice)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          CategorySelector(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF607D8B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  RecentChats(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddDialog(context);
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _performAction(String choice) {
    if (choice.compareTo('Search') == 0) {
    } else if (choice.compareTo('Log Out') == 0) AuthService.logout(context);
  }
}
