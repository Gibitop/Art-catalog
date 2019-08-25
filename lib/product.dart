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
      : super(key: key) {
        if (artwork.lazyLoading) {
          lazyCheck();
        }
      }

  Future<void> lazyCheck() async {
    while(!artwork.lazyLoading) {
      await Future.delayed(Duration(seconds: 1));
    } 
    // TODO: update state
  }

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
                          'Size',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          artwork.size,
                          style: Theme.of(context).textTheme.body1,
                        )
                      ]),

                      TableRow(children: <Widget>[
                        Text(
                          'Technique',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          artwork.lazyLoading ? 'Loading...' : artwork.technique,
                          style: Theme.of(context).textTheme.body1,
                        )
                      ]),

                      TableRow(children: <Widget>[
                        Text(
                          'Materials',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          artwork.lazyLoading ? 'Loading...' : artwork.materials,
                          style: Theme.of(context).textTheme.body1,
                        )
                      ]),

                      TableRow(children: <Widget>[
                        Text(
                          'Style',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          artwork.lazyLoading ? 'Loading...' : artwork.style,
                          style: Theme.of(context).textTheme.body1,
                        )
                      ]),

                      TableRow(children: <Widget>[
                        Text(
                          'Art form',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          artwork.lazyLoading ? 'Loading...' : artwork.artForm,
                          style: Theme.of(context).textTheme.body1,
                        )
                      ]),

                      TableRow(children: <Widget>[
                        Text(
                          'Subject and objects',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          artwork.lazyLoading ? 'Loading...' : artwork.subjects,
                          style: Theme.of(context).textTheme.body1,
                        )
                      ]),

                      TableRow(children: <Widget>[
                        Text(
                          'Date of creation',
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Text(
                          artwork.creationDate,
                          style: Theme.of(context).textTheme.body1,
                        )
                      ]),
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
