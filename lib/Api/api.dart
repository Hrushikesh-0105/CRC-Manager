import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://172.25.109.204:5500/booking';
  final String loginUrl = 'http://172.25.109.204:5500/login';

  // GET request
  Future<List<dynamic>?> getData(String roomName, String date) async {
    List<dynamic>? data;
    try {
      print('$baseUrl/all?roomName=$roomName&date=$date');
      final response = await http
          .get(Uri.parse('$baseUrl/all?roomName=$roomName&date=$date'));
      debugPrint("${response.statusCode}");

      if (response.statusCode == 200) {
        debugPrint("Raw Response: ${response.body}");

        data = jsonDecode(response.body);
        debugPrint("Decoded Response: $data");

        // Access data from the list
        // data.forEach((item) {
        //   print("RoomName: ${item['RoomName']}");
        //   print("Guest: ${item['Guest']}");
        //   print("Date: ${item['Date']}");
        //   print("BookedFrom: ${item['BookedFrom']}");
        //   print("BookedTill: ${item['BookedTill']}");
        //   print("Status: ${item['Status']}");
        // });
        return data;
      } else {
        debugPrint("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("hello");
      debugPrint("Error: $e");
    }
    return null;
  }

  // POST request
  Future<void> postData(Map<String, dynamic> body) async {
    // Map<String, dynamic> ret_map = {};
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      debugPrint(response.body);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint("Response from API (POST): ${data['message']}");
      } else {
        debugPrint("Failed to post data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // DELETE request
  Future<void> deleteData(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

      if (response.statusCode == 200) {
        debugPrint("Successfully deleted item with id: $id");
      } else {
        debugPrint("Failed to delete data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<int> authenticateLogin(String mobileNumber, String password) async {
    Map<String, dynamic> body = {
      "username": mobileNumber,
      "password": password
    };
    int statusCode = 0;
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        statusCode = 200;
        debugPrint("Logged in successfully");
      } else if (response.statusCode == 404) {
        statusCode = 404;
        debugPrint("Invalid mobile Number");
      } else if (response.statusCode == 401) {
        statusCode = 401;
        debugPrint("Incorrect password. Login failed.");
      } else if (response.statusCode == 500) {
        debugPrint("Server Error.");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return statusCode;
  }
}
