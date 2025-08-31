import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static initialDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.kBaseURL,
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String endPoint,
    Map<String, dynamic>? parameters,
    String? token,
  }) async {
    dio.options.headers = {
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    };
    return await dio.get(endPoint, queryParameters: parameters);
  }

  static Future<Response> postData({
    required String endPoint,
    Object? data,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? headers,
    String? token,
  }) async {
    dio.options.headers = headers ??
        {
          if (token != null) 'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        };
    return await dio.post(endPoint, queryParameters: parameters, data: data);
  }
}
