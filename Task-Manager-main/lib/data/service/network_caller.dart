import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/data/models/response_object.dart';
import 'package:http/http.dart';
import 'package:task_manager/presentation/controllers/auth_controller.dart';
import 'package:task_manager/presentation/screens/Auth/sing_in_screen.dart';

class NetworkCaller {
  static Future<ResponseObject> getRequest(String url) async {
    try {
      final Response response = await get(Uri.parse(url),
          headers: {"token": AuthController.accessToken ?? ""});
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        final decodeResponse = jsonDecode(response.body);
        return ResponseObject(
          statusCode: 200,
          responsBody: decodeResponse,
          isSuccess: true,
        );
      } else if (response.statusCode == 401) {
        _moveTosinIn();
        return ResponseObject(
          statusCode: response.statusCode,
          responsBody: "",
          isSuccess: false,
        );
      } else {
        return ResponseObject(
          statusCode: response.statusCode,
          responsBody: "",
          isSuccess: false,
        );
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
          isSuccess: false,
          statusCode: -1,
          responsBody: "",
          errorMessage: e.toString());
    }
  }

  static Future<ResponseObject> postRequest(
      String url, Map<String, dynamic> body,
      {bool fromsingIn = false}) async {
    try {
      final Response response = await post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          'content-type': "Application/json",
          "token": AuthController.accessToken ?? ""
        },
      );
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        final decodeResponse = jsonDecode(response.body);
        return ResponseObject(
            statusCode: 200, responsBody: decodeResponse, isSuccess: true);
      } else if (response.statusCode == 401) {
        if (fromsingIn) {
          return ResponseObject(
            statusCode: response.statusCode,
            responsBody: "",
            isSuccess: false,
          );
        } else {
          _moveTosinIn();
          return ResponseObject(
            statusCode: response.statusCode,
            responsBody: "",
            isSuccess: false,
          );
        }
      } else {
        return ResponseObject(
          statusCode: response.statusCode,
          responsBody: "",
          isSuccess: false,
        );
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
          isSuccess: false,
          statusCode: -1,
          responsBody: "",
          errorMessage: e.toString());
    }
  }

  static void _moveTosinIn() async {
    await AuthController.clearUserData();

    Navigator.pushAndRemoveUntil(
        TaskManager.navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => const SingInScreen(),
        ),
        (route) => false);
  }
}
