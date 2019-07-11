import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scrapper.g.dart';

@JsonSerializable()
class Artwork {
  String name;
  String size;
  String price;
  String image;
  String technique;

  Artwork();

  Map<String, dynamic> toJson() => _$ArtworkToJson(this);

  factory Artwork.fromJson(Map<String, dynamic> json) =>
      _$ArtworkFromJson(json);
}

const String notAvaliable = 'Data not available.';

class ArtWorkManager {
  static const artworkFile = 'artworks.json';
  static const configFile = 'ID';
  static const imgDir = 'img';
  static const imgSize = '200';

  List<Artwork> artworks = [];
  String id;
  Future<Directory> path;
  Function getID;
  Function updateUI;
  bool updateInProgress = false;
  bool _idNeeded = false;
  bool _mustLoginWas;

  ArtWorkManager() {
    this.getID = ({bool mustLogin: false}) {
      this._idNeeded = true;
      this._mustLoginWas = mustLogin;
      print('The getID function was not set yet');
    };
    this.updateUI = () {
      print('The updateUI function was not set yet');
    };
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

  void setUpdateUI(Function updateUI) {
    this.updateUI = updateUI;
    updateUI();
  }

  void setGetID(Function getID) {
    this.getID = getID;
    if (_idNeeded) {
      getID(mustLogin: _mustLoginWas);
      _idNeeded = false;
    }
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
    List<Element> linksElements = document.querySelectorAll('.c_span_link');
    List<String> infoLinks = [];
    for (var link in linksElements) {
      if (link.attributes.containsKey('href')) {
        infoLinks.add(baseURL + link.attributes['href']);
      }
    }

    // Get artwork image links
    List<Element> imageElements = document.querySelectorAll('img.c_set_work');
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
      updateUI();
      justifyImages();
    });
  }

  Future<void> setID(String newID) async {
    var path = await this.path;
    var config = File(path.path + '/$configFile');

    this.artworks = [];
    this.id = newID;
    print('new ID: $newID');
    config.writeAsString(id);
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
    updateUI();
    justifyImages();
  }

  Future<void> write() async {
    var path = await this.path;
    File(path.path + '/$artworkFile').writeAsString(json.encode(artworks));
  }

  Future<List<String>> listdir(String dirPath) async {
    List<String> list = [];
    Directory(dirPath).listSync().forEach((el) {
      list.add(basename(el.path));
    });
    return list;
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
}
