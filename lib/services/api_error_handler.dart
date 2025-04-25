import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    String errorMessage = 'An error occurred';

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Connection timeout';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = 'Send timeout';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Receive timeout';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Server error: ${error.response?.statusCode}';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Request cancelled';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'No internet connection';
          break;
        case DioExceptionType.unknown:
          errorMessage = 'Unknown error occurred';
          break;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
