// Dart
import 'dart:io';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as DOM;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Screens
import 'login.dart';
import 'help.dart';
import 'product.dart';

import 'artwork.dart';

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

  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  static const artworkFile = 'artworks.json';
  static const configFile = 'ID';
  static const imgDir = 'img';
  static const imgSize = '200';

  String id;
  Future<Directory> path;
  List<Artwork> artworks = [];
  List<Artwork> dispalyingList = [];
  bool updateInProgress = false;

  BuildContext context;
  String searchString = '';

  _CatalogState() {
    this.path = getApplicationDocumentsDirectory();
    this.path.then((Directory path) {
      var config = File(path.path + '/$configFile');
      if (config.existsSync()) {
        id = config.readAsStringSync();
        print('ID: $id');
        read().whenComplete(() {
          update();
        });
      } else {
        config.createSync();
        getID(mustLogin: true);
      }
    });
  }

  void _search(String value) {
    searchString = value;
    if (value.isNotEmpty) {
      dispalyingList = [];
      for (var artwork in artworks) {
        if (artwork.name.toLowerCase().contains(value.toLowerCase())) {
          dispalyingList.add(artwork);
        }
      }
    } else {
      dispalyingList = artworks;
    }
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

      var path = await this.path;
      var config = File(path.path + '/$configFile');
      artworks = [];
      id = newID;
      print('new ID: $newID');
      config.writeAsString(id);
      onLoading(update);
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

  Future<void> update() async {
    if (id.isEmpty) {
      getID();
      return;
    }

    if (updateInProgress) {
      print('Update is already in progress');
      return;
    }
    print('Scrapping started');
    updateInProgress = true;

    List<Artwork> out = [];

    var baseURL = 'https://artchive.ru';
    var client = Client();
    Response response =
        await client.get(baseURL + '/artists/' + id + '/works/all:2');
    var document = parse(response.body);

    // Get artwork info links
    List<DOM.Element> linksElements = document.querySelectorAll('.c_span_link');
    List<String> infoLinks = [];
    for (var link in linksElements) {
      if (link.attributes.containsKey('href')) {
        infoLinks.add(baseURL + link.attributes['href']);
      }
    }

    // Get artwork image links
    List<DOM.Element> imageElements =
        document.querySelectorAll('img.c_set_work');
    for (var link in imageElements) {
      out.add(Artwork());
      out[out.length - 1].image =
          link.attributes['src'].split('work/')[1].replaceAll('/', '.');
    }

    for (var link = 0; link < infoLinks.length; link++) {
      response = await client.get(infoLinks[link]);
      document = parse(response.body);
      try {
        out[link].name = document
            .querySelector('h1#id_work_name')
            .text
            .split('/')[0]
            .replaceAll('"', '');
      } catch (igonre) {}
      try {
        out[link].price = document.querySelector('div.item-cost').text;
      } catch (igonre) {}
      var data =
          document.querySelectorAll('div.artwork-option__description > p');
      try {
        out[link].size = data[6].text.replaceAll('Размер: ', '');
      } catch (igonre) {}
      try {
        out[link].technique = data[3].text.replaceAll('Техника: ', '');
      } catch (igonre) {}
    }

    artworks = out;
    updateInProgress = false;
    print('Scrapping finished');
    write();
    downloadImages().whenComplete(() {
      setState(() {
        dispalyingList = artworks;
        _search(searchString);
      });
      justifyImages();
    });
  }

  Future<void> read() async {
    var path = await this.path;
    String content = File(path.path + '/$artworkFile').readAsStringSync();
    if (content.isEmpty) {
      update();
      return;
    }
    List<dynamic> data = json.decode(content);
    artworks = [];
    for (var artwork in data) {
      artworks.add(Artwork.fromJson(artwork));
    }
    setState(() {
      dispalyingList = artworks;
      _search(searchString);
    });
    justifyImages();
  }

  Future<void> write() async {
    var path = await this.path;
    File(path.path + '/$artworkFile').writeAsString(json.encode(artworks));
  }

  Future<void> downloadImages() async {
    var path = Directory((await this.path).path + '/$imgDir');
    List<String> list = [];
    if (path.existsSync()) {
      list = await listdir(path.path);
    } else {
      path.createSync();
    }
    var client = HttpClient();
    for (var artwork in artworks) {
      if (!list.contains(artwork.image)) {
        print('Downloading an image for ${artwork.name}');
        String url =
            'https://artchive.ru/res/media/img/ox$imgSize/work/${artwork.image.replaceFirst('.', '/')}';
        var _downloadData = List<int>();
        var fileSave = File(path.path + '/${artwork.image}');
        client.getUrl(Uri.parse(url)).then((request) {
          return request.close();
        }).then((response) {
          response.listen((data) => _downloadData.addAll(data), onDone: () {
            fileSave.writeAsBytes(_downloadData);
          });
        });
      }
    }
  }

  Future<void> justifyImages() async {
    var path = Directory((await this.path).path + '/$imgDir');
    if (path.existsSync()) {
      var list = await listdir(path.path);
      for (var image in list) {
        var needed = false;
        for (var artwork in artworks) {
          if (artwork.image == image) {
            needed = true;
            break;
          }
        }
        if (!needed) {
          File('${path.path}/$image').delete();
        }
      }
    } else {
      path.createSync();
      return;
    }
  }

  Future<List<String>> listdir(String dirPath) async {
    List<String> list = [];
    Directory(dirPath).listSync().forEach((el) {
      list.add(basename(el.path));
    });
    return list;
  }

  Future<File> getImage(name) async {
    var file = File('${(await path).path}/$imgDir/$name');
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
              print(dispalyingList);
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
                        if (updateInProgress) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('An update is already in progress!'),
                          ));
                          return null;
                        } else {
                          return update();
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Product(
                                            title: this.widget.title,
                                            artwork: item,
                                            image: getImage(item.image),
                                          )));
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
