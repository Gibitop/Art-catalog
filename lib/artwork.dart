import 'package:json_annotation/json_annotation.dart';
part 'artwork.g.dart';

const String dataNotAvaliable = 'Data not available';

@JsonSerializable()
class Artwork {
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
