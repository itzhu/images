import 'package:dio/dio.dart';

/// des: dio 封装
/// http://laomengit.com/guide/data_storage/dio.html
class HttpManager {

  static const int CONNECT_TIMEOUT = 50000;
  static const int RECEIVE_TIMEOUT = 30000;

  Dio get http => _dio;
  late Dio _dio;

  HttpManager(){
    var options = BaseOptions(connectTimeout: CONNECT_TIMEOUT, receiveTimeout: RECEIVE_TIMEOUT);
    _dio = Dio(options)..interceptors.add(LogInterceptor(requestBody: true,responseBody: false));
  }

  Dio getClient(){
    return _dio;
  }

}
