import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Help extends StatelessWidget {
  final String title;
  Help({Key key, @required this.title}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
