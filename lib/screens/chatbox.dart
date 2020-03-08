import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;


String name;

class ChatBox extends StatefulWidget {
  final String Name;

  ChatBox({this.Name}) {
    name = Name;
  }

  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final _firestore = Firestore.instance;
  DocumentSnapshot ds;
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) loggedInUser = user;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Stream<QuerySnapshot> getStream() async* {
    yield* _firestore.collection('chatbox').snapshots();
  }

  Widget _buildMessageComposer() {
    TextEditingController _controller = new TextEditingController();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              cursorColor: Theme.of(context).primaryColor,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Color(0xFF263238),
            onPressed: () {
              _firestore
                  .collection('chatbox')
                  .document(ds.documentID)
                  .collection('messages')
                  .add({
                'text': _controller.text,
                'sender': loggedInUser.email,
                'createdAt': Timestamp.now(),
              });
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF263238),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        title: Center(
          child: Text(
            name,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238)),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            iconSize: 25.0,
            color: Color(0xFF263238),
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: getStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            for (int i = 0;
                                i < snapshot.data.documents.length;
                                i++) {
                              print(snapshot.data.documents[i]['name']);
                              if (name.compareTo(snapshot
                                      .data.documents[i]['name']
                                      .toString()) ==
                                  0) {
                                ds = snapshot.data.documents[i];
                                break;
                              }
                            }

                            print(ds.documentID.toString());

                            return StreamBuilder<QuerySnapshot>(
                                stream: _firestore
                                    .collection('chatbox')
                                    .document(ds.documentID)
                                    .collection('messages').orderBy('createdAt',descending: false)
                                    .snapshots(),
                                builder: (context, messageSnapshot) {
                                  if (messageSnapshot.hasData) {
                                    final messages = messageSnapshot.data.documents.reversed;
                                        List<Message> messageList = [];
                                        for (var message
                                            in messages) {
                                          final messageText =
                                              message.data['text'].toString();
                                          final sender =
                                              message.data['sender'].toString();
                                          final timeCreated = timeago.format(message.data['createdAt'].toDate());
                                          print("$messageText from $sender");

                                          final messageWidget = Message(
                                            sender: sender,
                                            messageText: messageText,
                                            timeCreated: timeCreated,
                                            isMe: sender.compareTo(loggedInUser.email) == 0,
                                          );
                                          messageList.add(messageWidget);
                                        }

                                        return ListView(
                                          reverse: true,
                                          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 20.0),
                                          children: messageList,
                                        );

                                  }
                                  return Text("Loading...");
                                });
                          }
                          return CircularProgressIndicator();
                        }),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildMessageComposer(),
            ),
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final sender;
  final messageText;
  final isMe;
  final timeCreated;

  Message({this.sender, this.messageText,this.timeCreated,this.isMe});

  @override
  Widget build(BuildContext context) {

    final Container msg = Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0,right: 80.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).primaryColor : Color(0xFF263238),
        borderRadius: isMe
            ? BorderRadius.only(
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0))
            : BorderRadius.only(
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            timeCreated,
            style: TextStyle(
                color: isMe ? Colors.black : Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.0),
          Text(
            sender,
            style: TextStyle(
                color: isMe ? Colors.black : Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 8.0),
          Text(
            messageText,
            style: TextStyle(
                color: isMe ? Colors.black : Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    return msg;
  }
}
