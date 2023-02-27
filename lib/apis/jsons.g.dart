// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jsons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImagesJson _$ImagesJsonFromJson(Map<String, dynamic> json) => ImagesJson()
  ..queryExt = json['queryExt'] as String?
  ..displayNum = json['displayNum'] as int?
  ..data = (json['data'] as List<dynamic>?)
      ?.map((e) => ImageInfo.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ImagesJsonToJson(ImagesJson instance) =>
    <String, dynamic>{
      'queryExt': instance.queryExt,
      'displayNum': instance.displayNum,
      'data': instance.data,
    };

ImageInfo _$ImageInfoFromJson(Map<String, dynamic> json) => ImageInfo()
  ..thumbURL = json['thumbURL'] as String?
  ..middleURL = json['middleURL'] as String?
  ..hoverURL = json['hoverURL'] as String?
  ..type = json['type'] as String?
  ..width = json['width'] as int?
  ..height = json['height'] as int?
  ..fromPageTitle = json['fromPageTitle'] as String?
  ..replaceUrl = (json['replaceUrl'] as List<dynamic>?)
      ?.map((e) =>
          e == null ? null : OriginUrl.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ImageInfoToJson(ImageInfo instance) => <String, dynamic>{
      'thumbURL': instance.thumbURL,
      'middleURL': instance.middleURL,
      'hoverURL': instance.hoverURL,
      'type': instance.type,
      'width': instance.width,
      'height': instance.height,
      'fromPageTitle': instance.fromPageTitle,
      'replaceUrl': instance.replaceUrl,
    };

OriginUrl _$OriginUrlFromJson(Map<String, dynamic> json) => OriginUrl()
  ..ObjUrl = json['ObjUrl'] as String?
  ..FromUrl = json['FromUrl'] as String?;

Map<String, dynamic> _$OriginUrlToJson(OriginUrl instance) => <String, dynamic>{
      'ObjUrl': instance.ObjUrl,
      'FromUrl': instance.FromUrl,
    };
