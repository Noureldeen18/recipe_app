import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio; // Make dio nullable

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.themealdb.com/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response?> getData({
    required String url,
    Map<String , dynamic>? query,

  })async{
    return await dio?.get(url,queryParameters:query, );
  }
}