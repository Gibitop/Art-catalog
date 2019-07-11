// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artwork _$ArtworkFromJson(Map<String, dynamic> json) {
  return Artwork()
    ..name = json['name'] as String
    ..size = json['size'] as String
    ..price = json['price'] as String
    ..image = json['image'] as String
    ..technique = json['technique'] as String;
}

Map<String, dynamic> _$ArtworkToJson(Artwork instance) => <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'price': instance.price,
      'image': instance.image,
      'technique': instance.technique
    };
