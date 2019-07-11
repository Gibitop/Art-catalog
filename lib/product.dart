import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'artwork.dart';

class Product extends StatelessWidget {
  final Artwork artwork;
  final String title;
  final Future<File> image;
  Product(
      {Key key,
      @required this.title,
      @required this.artwork,
      @required this.image})
      : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: FutureBuilder(
                future: image,
                builder: (context, snapshot) {
                  return snapshot.data != null
                      ? Image.file(snapshot.data)
                      : Container(
                          child: Icon(
                            Icons.image,
                            size: 40,
                          ),
                          padding: EdgeInsets.all(8),
                        );
                }),
          ),
          Text(artwork.name),
          Text(artwork.price),
          Text(artwork.size),
          Text(artwork.technique),
        ],
      ),
    );
  }
}
