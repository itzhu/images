/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'package:images/apis/ImagesApi.dart';
import 'package:json_annotation/json_annotation.dart';

///create by itz on 2022/11/14 16:10
///desc : flutter packages pub run build_runner build

part 'jsons.g.dart';

@JsonSerializable()
class ImagesJson {
  String? queryExt;
  int? displayNum;
  List<ImageInfo>? data;

  ImagesJson();

  factory ImagesJson.fromJson(Map<String, dynamic> json) => _$ImagesJsonFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesJsonToJson(this);
}

@JsonSerializable()
class ImageInfo {
  String? thumbURL;
  String? middleURL;
  String? hoverURL;
  String? type;
  int? width;
  int? height;
  String? fromPageTitle;
  List<OriginUrl?>? replaceUrl;

  ImageInfo();

  factory ImageInfo.fromJson(Map<String, dynamic> json) => _$ImageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ImageInfoToJson(this);

  bool isValid() {
    if ((thumbURL == null && middleURL == null && hoverURL == null) || fromPageTitle == null) {
      return false;
    }
    return true;
  }

  String getUrl() {
    return thumbURL!;
  }

  String getDownloadUrl() {
    var url = replaceUrl?[0]?.ObjUrl;
    if(url==null)return thumbURL!;
    return  ImagesApi.getImageDownloadUrl(url, thumbURL!);
  }

  int getWidth() {
    return width ?? 100;
  }

  int getHeight() {
    return height ?? 100;
  }

  int showFlex() {
    return getWidth()~/400+20;
  }

  ///return ".$type"
  String getDType() {
    return ".$type";
  }
}

@JsonSerializable()
class OriginUrl {
  String? ObjUrl;
  String? FromUrl;

  OriginUrl();

  factory OriginUrl.fromJson(Map<String, dynamic> json) => _$OriginUrlFromJson(json);

  Map<String, dynamic> toJson() => _$OriginUrlToJson(this);
}
