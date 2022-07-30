import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider((ref) => ApiService());
const String _endPoint = "https://mobilepos.systemsexpert.com.sa/Example/verifyUser";

class ApiService {
  final Dio dio = Dio(BaseOptions());
  //==================== Validate User ====================
  Future<bool> validateUser(String phoneNumber) async {
    try {
      Map params = {"PhoneNumber": phoneNumber};
      final Response response = await dio.post(_endPoint, data: jsonEncode(params));
      log('response == ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bool status = response.data['status'];
        return status;
      } else {
        return false;
      }
    } on Exception catch (e) {
      log('Exception : $e');
      return false;
    }
  }
}
