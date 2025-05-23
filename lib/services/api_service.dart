import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:ds_ai_project_ui/components/recognition_result.dart';
import 'package:ds_ai_project_ui/utils/api_exception.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://192.168.18.137:8000';

  Future<bool> _pingServer() async {
    //   try {
    //     final socket = await Socket.connect('192.168.18.143', 5000,
    //         timeout: const Duration(seconds: 2));
    //     socket.destroy();
    //     return true;
    //   } catch (_) {
    //     return false;
    //   }
    return true;
  }

  Future<RecognitionResult> recognizeHandwriting({
    required Uint8List imageBytes,
    required String modelType,
  }) async {
    try {
      final isReachable = await _pingServer();
      if (!isReachable) {
        throw ApiException(message: 'Server is unreachable');
      }

      final request =
          http.MultipartRequest('POST', Uri.parse('$_baseUrl/predict'))
            ..headers.addAll({
              'Accept': 'application/json',
              'Connection': 'keep-alive',
            })
            ..files.add(http.MultipartFile.fromBytes(
              'file',
              imageBytes,
              filename: 'whiteboard.png',
            ))
            ..fields['model_type'] = modelType;

      // Send request
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      log('Response: $responseString');
      log('Status Code: ${response.statusCode}');
      log('Response Headers: ${response.headers}');
      log('Response Body: $responseString');
      log('Request URL: ${request.url}');
      if (response.statusCode == 200) {
        final responseData = json.decode(responseString);
        return RecognitionResult.fromJson(responseData);
      } else {
        final errorData = json.decode(responseString);
        throw ApiException(
          message: errorData['error'] ?? 'Failed to recognize handwriting',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'No Internet connection');
    } on FormatException {
      throw ApiException(message: 'Invalid API response format');
    } catch (e) {
      log('Error: $e');
      throw ApiException(message: 'An unexpected error occurred');
    }
  }
}
