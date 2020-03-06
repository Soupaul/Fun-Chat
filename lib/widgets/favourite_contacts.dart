import 'package:flutter/material.dart';
import 'package:fun_chat/models/message_model.dart';
import 'package:fun_chat/screens/chat_screen.dart';

class FavouriteContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Favourite Contacts",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Colors.white,//Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz),
                  iconSize: 30.0,
                  color: Colors.white,//Theme.of(context).primaryColor,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 120.0,
          child: ListView.builder(
              padding: EdgeInsets.only(
                left: 10.0,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: favourites.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        user: favourites[index],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage: AssetImage(favourites[index].imageUrl),
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          favourites[index].name,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.amberAccent,//Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
  }
}
