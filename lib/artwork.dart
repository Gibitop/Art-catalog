import 'package:json_annotation/json_annotation.dart';
part 'artwork.g.dart';

const String dataNotAvaliable = 'Data not available';

// To build a part file use "flutter pub run build_runner build" command
@JsonSerializable()
class Artwork {
  // TODO: Add field "creation date"
  // TODO: Add field "type"
  // TODO: Add field "objects and themes"
  // TODO: Add field "description"
  
  String name = dataNotAvaliable;
  String size = dataNotAvaliable;
  String price = dataNotAvaliable;
  String image = dataNotAvaliable;
  String technique = dataNotAvaliable;

  Artwork();

  Map<String, dynamic> toJson() => _$ArtworkToJson(this);

  factory Artwork.fromJson(Map<String, dynamic> json) =>
      _$ArtworkFromJson(json);
}
