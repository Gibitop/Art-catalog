// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artwork _$ArtworkFromJson(Map<String, dynamic> json) {
  return Artwork()
    ..workID = json['workID'] as String
    ..image = json['image'] as String
    ..lazyLoading = json['lazyLoading'] as bool
    ..name = json['name'] as String
    ..price = json['price'] as String
    ..size = json['size'] as String
    ..technique = json['technique'] as String
    ..materials = json['materials'] as String
    ..style = json['style'] as String
    ..artForm = json['artForm'] as String
    ..subjects = json['subjects'] as String
    ..creationDate = json['creationDate'] as String
    ..description = json['description'] as String;
}

Map<String, dynamic> _$ArtworkToJson(Artwork instance) => <String, dynamic>{
      'workID': instance.workID,
      'image': instance.image,
      'lazyLoading': instance.lazyLoading,
      'name': instance.name,
      'price': instance.price,
      'size': instance.size,
      'technique': instance.technique,
      'materials': instance.materials,
      'style': instance.style,
      'artForm': instance.artForm,
      'subjects': instance.subjects,
      'creationDate': instance.creationDate,
      'description': instance.description,
    };
