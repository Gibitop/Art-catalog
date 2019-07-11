import 'package:json_annotation/json_annotation.dart';
part 'artwork.g.dart';

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
