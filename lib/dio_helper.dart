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
    Map<String, dynamic>? query,
  }) async {
    return await dio?.get(url, queryParameters: query);
  }

  // إضافة دالة جديدة للبحث عن الوصفات بالاسم
  static Future<Response?> searchRecipesByName(String name) async {
    return await getData(
      url: 'api/json/v1/1/search.php',
      query: {'s': name},
    );
  }

  // إضافة دالة جديدة للبحث عن وصفة باستخدام id الوصفة
  static Future<Response?> getRecipeById(String id) async {
    return await getData(
      url: 'api/json/v1/1/lookup.php',
      query: {'i': id},
    );
  }
}
