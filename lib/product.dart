import 'package:art_catalog/scrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Product extends StatelessWidget {
  final Artwork artwork;
  final String title;
  Product({Key key, @required this.title, @required this.artwork})
      : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(0),
            iconSize: 32,
            icon: Icon(Icons.help),
            onPressed: () {
              print('SHOW "ABOUT" PAGE');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[],
      ),
    );
  }
}
