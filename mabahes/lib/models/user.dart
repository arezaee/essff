import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

Logger logger = Logger();

class User {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String address;
  final String phoneNumber;

  User({
    @required this.username,
    @required this.password,
    @required this.firstName,
    @required this.lastName,
    @required this.address,
    @required this.phoneNumber,
  });

  Future<Map<String, dynamic>> login(username, password) async {
    //        ¯\_(ツ)_/¯

    Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
    };
    try {
      http.Response response = await http
          .post(
            '  ¯\_(ツ)_/¯  ',
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(requestBody),
          )
          .timeout(Duration(seconds: 30));

      Map<String, dynamic> responseJson = json.decode(response.body);

      return {
        'ok': responseJson['ok'],
        'errorCode': responseJson['errorCode'],
        'data': responseJson['data'] ?? null,
      };
    } catch (error) {
      logger.e(error);
      return {
        'ok': false,
        'errorCode': 100,
      };
    }
  }

  Future<Map<String, dynamic>> register(
      username, password, firstName, lastName, address, phoneNumber) async {
    //        ¯\_(ツ)_/¯

    Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'phoneNumber': phoneNumber,
    };
    try {
      http.Response response = await http
          .post(
            '  ¯\_(ツ)_/¯  ',
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(requestBody),
          )
          .timeout(Duration(seconds: 30));

      Map<String, dynamic> responseJson = json.decode(response.body);

      return {
        'ok': responseJson['ok'],
        'errorCode': responseJson['errorCode'],
        'data': responseJson['data'] ?? null,
      };
    } catch (error) {
      logger.e(error);
      return {
        'ok': false,
        'errorCode': 100,
      };
    }
  }
}
