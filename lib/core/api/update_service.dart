import 'dart:convert';
import 'package:dakeh_service_provider/core/utils/version_utils.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateServiceException implements Exception {
  final String message;
  final int? statusCode;

  UpdateServiceException({required this.message, this.statusCode});

  @override
  String toString() => "UpdateServiceException: $message (code: $statusCode)";
}

class UpdateService {
  final String configURL;
  final Dio _dio;

  UpdateService({required this.configURL, Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
              ),
            );

  Future<String?> _getMinSupportedVersion() async {
    try {
      final resp = await _dio.get(configURL);
      if (resp.statusCode != 200) {
        throw UpdateServiceException(
          message: 'unexpected_status_code'.tr(),
          statusCode: resp.statusCode,
        );
      }
      if (resp.data == null) {
        throw UpdateServiceException(message: 'empty_response_body'.tr());
      }

      final Map<String, dynamic> jsonData = resp.data is String
          ? jsonDecode(resp.data as String)
          : (resp.data['data'] as Map<String, dynamic>);
      final rules = (defaultTargetPlatform == TargetPlatform.iOS)
          ? jsonData['provider_apple_version']
          : jsonData['provider_google_version'];
      if (rules == null) {
        throw UpdateServiceException(
          message: 'unknown_error'.tr(namedArgs: {'error': ''}),
        );
      }
      return rules as String?;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw UpdateServiceException(message: 'connection_timeout'.tr());
        case DioExceptionType.receiveTimeout:
          throw UpdateServiceException(message: 'receive_timeout'.tr());
        case DioExceptionType.badResponse:
          throw UpdateServiceException(
            message:
                'bad_response'.tr(namedArgs: {'response': e.response?.data}),
            statusCode: e.response?.statusCode,
          );
        default:
          throw UpdateServiceException(
              message:
                  'network_error'.tr(namedArgs: {"error": e.message ?? ''}));
      }
    } on FormatException {
      throw UpdateServiceException(message: 'invalid_json_format'.tr());
    } catch (e) {
      throw UpdateServiceException(
          message: 'unknown_error'.tr(namedArgs: {'error': e.toString()}));
    }
  }

  Future<bool> needsUpdate() async {
    final info = await PackageInfo.fromPlatform();
    final current = info.version;
    final minimum = await _getMinSupportedVersion();
    if (minimum == null || minimum.isEmpty) return false;
    return compareSemver(current, minimum) < 0;
  }
}
