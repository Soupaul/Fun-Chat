import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  var _categories = [
    'Chatboxes' /*, 'Online', 'Groups', 'Requests'*/
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      color: Theme.of(context).primaryColor,
      child: Center(
          child: Text(
        'Chatboxes',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      )),
//      child: ListView.builder(
//          scrollDirection: Axis.horizontal,
//          itemCount: _categories.length,
//          itemBuilder: (BuildContext context, int index) {
//            return GestureDetector(
//              onTap: (){
//                setState(() {
//                  selectedIndex = index;
//                });
//              },
//              child: Padding(
//                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
//                  child: Text(
//                    _categories[index],
//                    style: TextStyle(
//                      color: index == selectedIndex ? Color(0xFF263238) : Colors.black12,
//                      fontSize: 20.0,
//                      fontWeight: FontWeight.bold,
//                      letterSpacing: 1.2,
//                    ),
//                  )),
//            );
//          }),
    );
  }
}
