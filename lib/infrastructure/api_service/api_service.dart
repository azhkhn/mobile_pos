import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider((ref) => ApiService());
const String _endPoint = "http://mobilepos.systemsexpert.com.sa/Example/verifyUser";

class ApiService {
  final Dio dio = Dio(BaseOptions());
  //==================== Validate User ====================
  Future<int> validateUser({required String phoneNumber, required String secretKey}) async {
    try {
      Map params = {"phoneNumber": phoneNumber, "secretKey": secretKey};
      final Response response = await dio.post(_endPoint, data: jsonEncode(params));
      log('response == ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final int status = response.data['status'];
        return status;
      } else {
        throw SocketException;
      }
    } catch (_) {
      // log('Exception : $e');
      rethrow;
    }
  }
}
