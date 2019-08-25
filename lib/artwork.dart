import 'package:json_annotation/json_annotation.dart';
part 'artwork.g.dart';

const String dataNotAvaliable = 'Data not available';

// To build a part file use "flutter pub run build_runner build" command
@JsonSerializable()
class Artwork {  
  String workID = dataNotAvaliable;
  String image = dataNotAvaliable;
  bool lazyLoading = false;

  String name = dataNotAvaliable;
  String price = dataNotAvaliable;
  String size = dataNotAvaliable;

  // Lazy loaded:
  String technique = dataNotAvaliable;
  String materials = dataNotAvaliable;
  String style = dataNotAvaliable;
  String artForm = dataNotAvaliable;
  String subjects = dataNotAvaliable;

  String creationDate = dataNotAvaliable;
  
  String description = dataNotAvaliable;

  Artwork();

  Map<String, dynamic> toJson() => _$ArtworkToJson(this);

  factory Artwork.fromJson(Map<String, dynamic> json) =>
      _$ArtworkFromJson(json);
}
