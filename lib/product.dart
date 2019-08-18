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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
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
                  },
                ),
                constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.width),
                margin: EdgeInsets.all(10),
              ),
            ),
            // Spacer(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    artwork.name,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Text(
                    artwork.price,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  Container(
                    height: 10,
                  ),
                  Table(
                    defaultColumnWidth: FractionColumnWidth(.1),
                    children: <TableRow>[
                      TableRow(children: <Widget>[
                        Text(
                          'Size:',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          artwork.size,
                          style: Theme.of(context).textTheme.body1,
                        )
                      ]),
                      TableRow(children: <Widget>[
                        Text(
                          'Technique:',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          artwork.technique,
                          style: Theme.of(context).textTheme.body1,
                        )
                      ]),
                      // TODO: Add other fields
                    ],
                  ),
                  // TODO: Add an artwork description
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
