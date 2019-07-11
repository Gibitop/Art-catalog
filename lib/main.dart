import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'login.dart';
import 'help.dart';
import 'product.dart';

import 'dart:io';
import 'scrapper.dart';

void main() => runApp(Root());

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Catalog(title: 'Art catalog'),
    );
  }
}

class Catalog extends StatefulWidget {
  Catalog({Key key, this.title}) : super(key: key);

  final String title;
  final ArtWorkManager manager = ArtWorkManager();

  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  _CatalogState() {
    checkReady();
  }
  BuildContext context;
  List<Artwork> dispalyingList = [];
  String searchString = '';

  checkReady() async {
    while (widget == null) {
      await Future.delayed(const Duration(seconds: 1));
    }
    print('Ready');
    widget.manager.setUpdateUI(updateUI);
    widget.manager.setGetID(getID);
  }

  void _search(String value) {
    searchString = value;
    if (value.isNotEmpty) {
      dispalyingList = [];
      for (var artwork in widget.manager.artworks) {
        if (artwork.name.toLowerCase().contains(value.toLowerCase())) {
          dispalyingList.add(artwork);
        }
      }
    } else {
      dispalyingList = widget.manager.artworks;
    }
    setState(() {});
  }

  updateUI() {
    print('UpdateUI');
    dispalyingList = widget.manager.artworks;
    _search(searchString);
    setState(() {});
  }

  getID({bool mustLogin: false}) async {
    String newID = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Login(title: widget.title, mustLogin: mustLogin)));

    if (newID != null && newID.isNotEmpty) {
      this.dispalyingList = [];
      await widget.manager.setID(newID);
      onLoading(widget.manager.update);
    }
  }

  void onLoading(Function load) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Dialog(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: CircularProgressIndicator(),
                  padding: EdgeInsets.all(20),
                ),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
    load().whenComplete(() {
      Navigator.pop(context);
    });
  }

  Future<File> getImage(name) async {
    var file = File(
        '${(await widget.manager.path).path}/${ArtWorkManager.imgDir}/$name');
    while (!file.existsSync()) {
      await Future.delayed(const Duration(seconds: 1));
    }
    return file;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(0),
            iconSize: 32,
            icon: Icon(Icons.account_circle),
            onPressed: getID,
          ),
          IconButton(
            padding: EdgeInsets.all(0),
            iconSize: 32,
            icon: Icon(Icons.help),
            onPressed: () {
              // print('SHOW "ABOUT" PAGE');
              onLoading(() {
                return Future.delayed(Duration(seconds: 3));
              });
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Name of an artwork'),
              onChanged: _search,
            ),
            Expanded(
              child: Builder(
                builder: (context) => RefreshIndicator(
                      onRefresh: () {
                        if (widget.manager.updateInProgress) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('An update is already in progress!'),
                          ));
                          return null;
                        } else {
                          return widget.manager.update();
                        }
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: dispalyingList.length,
                        itemBuilder: (context, index) {
                          final item = dispalyingList[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text(item.price),
                            leading: Container(
                              constraints: BoxConstraints(
                                minWidth: 60,
                                maxWidth: 60,
                              ),
                              child: FutureBuilder(
                                  future: getImage(item.image),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<File> snapshot) {
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
                            onTap: () {
                              print('tap');
                            },
                          );
                        },
                      ),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
