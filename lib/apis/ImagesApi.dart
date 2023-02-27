/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'dart:convert';

import 'package:images/app.dart';
import 'package:images/app_const.dart';
import 'package:images/common/util/log_util.dart';

import 'jsons.dart';

///create by itz on 2022/11/14 15:12
///desc :
class ImagesApi {

  static const String TEST_URL = "https://image.baidu.com/search/index?"
      "tn=resulttagjson"
      "&logid=8139296388188334198"
      "&ie=utf-8"
      "&fr=ala"
      //"&word=壁纸"
      "&ipn=r"
      "&fm=index"
      "&pos=history"
      // "&queryWord=壁纸"
      "&cl=2"
      "&lm=-1"
      "&oe=utf-8"
      "&adpicid="
      "&st="
      "&z="
      //"&ic=1024"
      "&hd="
      "&latest="
      "&copyright="
      "&s="
      "&se="
      "&tab="
      //"&width="
      //"&height="
      "&face="
      "&istype="
      "&qc="
      "&nc="
      "&expermode="
      "&nojc=";

  //"&isAsync=true"
  //"&pn=0"
  //"&rn=30"
  //"&gsm=3c"
  //"&1668409525570=";

  ///[word] 可以一个字符，也可多个，空格分开。如：壁纸 古风 二次元；美女；风景
  ///[pageIndexNumber]加载页数开始的位置，第一页 0
  ///[rangeNumber]每页的数量 默认：30
  ///[color] 图片颜色 (512,黑色)(1,红色)(64,粉色)(1024,白色)...
  ///[width] 图片宽度
  ///[height] 图片高度
  static String getImgListUrl(
      {required String word, int pageIndexNumber = 0, int rangeNumber = 30, int? color, int? width, int? height}) {
    StringBuffer buffer = StringBuffer();
    buffer.write("&word=$word");
    buffer.write("&pn=$pageIndexNumber");
    buffer.write("&rn=$rangeNumber");
    buffer.write("&ic=${color ?? ""}");
    buffer.write("&width=${width ?? ""}");
    buffer.write("&height=${height ?? ""}");
    buffer.write("&${DateTime.now().millisecondsSinceEpoch}=");
    //安全验证
    buffer.write(
        "&p_tk=3302BK7hxMqXfpzUMxtceBsVfoT47/XBO1g//A7lRsCmXHTY+27l22pNIED7uKUPYgfb7eo0Duju3u+Ahp4VF45t2/d4WnPoyOWbWDx81MAJOT3tN5eSYkgoaaUb+quXb1vQIFaXnpAWiH1FDhiXvOdBBg==&p_timestamp=1668496585&p_sign=7914b786784be0df0bd5c78aca34cbeb&p_signature=d393cc03dc9f60800e400b65a6fa187d&__pc2ps_ab=3302BK7hxMqXfpzUMxtceBsVfoT47/XBO1g//A7lRsCmXHTY+27l22pNIED7uKUPYgfb7eo0Duju3u+Ahp4VF45t2/d4WnPoyOWbWDx81MAJOT3tN5eSYkgoaaUb+quXb1vQIFaXnpAWiH1FDhiXvOdBBg==|1668496585|d393cc03dc9f60800e400b65a6fa187d|7914b786784be0df0bd5c78aca34cbeb");
    return TEST_URL + buffer.toString();
  }

  static Future<HttpResponse<ImagesJson>> getImagesJson(String url) async {
    HttpResponse<ImagesJson> httpResp = HttpResponse<ImagesJson>();
    var resp = await App.getHttpManager().getClient().get(url);
    if (resp.statusCode == 200) {
      try {
        ImagesJson imagesJson = ImagesJson.fromJson(jsonDecode(resp.data.toString()));
        httpResp.code = HttpResponse.SUCCESS;
        httpResp.data = imagesJson;
      } catch (e) {
        LogUtil.e("ImagesApi", "data err:$e");
        httpResp.code = HttpResponse.ERROR_DATA;
      }
    } else {
      httpResp.code = resp.statusCode ?? 0;
    }
    return Future.value(httpResp);
  }

  static const String DOWNLOAD_URL =
      "https://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result";

  //注意url和thumburl 是需要全url编码的
  //https://image.baidu.com/search/down?tn=download&ipn=dwnl&word=download&ie=utf8&fr=result
  // &url=https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fphoto%2F2008-3-18%2F200803181719402627.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1671178270&t=c8ec2f8d13e77205526bfdd477f0426f
  // &thumburl=https://img2.baidu.com/it/u=3074632858,4165691261&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500
  static String getImageDownloadUrl(String url, String thumbUrl) {
    return "$DOWNLOAD_URL&url=${Uri.encodeComponent(url)}&thumburl=${Uri.encodeComponent(thumbUrl)}";
  }
}

class HttpResponse<T> {
  static const SUCCESS = AppCode.REQUEST_SUCCESS;
  static const ERROR_DATA = AppCode.REQUEST_ERROR_DATA;

  ///[SUCCESS] 成功
  ///[ERROR_DATA] 数据解析失败
  ///other code,查看http错误码。为0表示请求异常
  int code = 0;
  T? data;
}
