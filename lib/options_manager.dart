import 'package:flutter/material.dart';

class Options extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Options();
  }
}

class _Options extends State<Options>{
  String dropdownValue = 'Triple Riding';

  Widget build(BuildContext context){
    return DropdownButton<String>(
    value: dropdownValue,
    icon: Icon(Icons.arrow_downward),
    iconSize: 24,
    elevation: 16,
    style: TextStyle(
      color: Colors.deepPurple
    ),
    underline: Container(
      height: 2,
      color: Colors.deepPurpleAccent,
    ),
    onChanged: (String newValue) {
      setState(() {
        dropdownValue = newValue;
      });
    },
    items: <String>['Triple Riding', 'No Helment', 'No Parking Area',
     'One Way Violation', 'Riding On The Footpaths']
      .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })
      .toList(),
  );
  } 
}