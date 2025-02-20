import 'dart:convert';
import 'package:crc_app/Api/secrets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = ApiSecrets.baseUrl;
  final String loginUrl = ApiSecrets.loginUrl;

  // GET request
  Future<List<Map<String, dynamic>>?> getData(
      String roomName, String date) async {
    List<Map<String, dynamic>>? dataList;
    try {
      debugPrint('$baseUrl/all?roomName=$roomName&date=$date');
      final response = await http
          .get(Uri.parse('$baseUrl/all?roomName=$roomName&date=$date'));
      debugPrint("${response.statusCode}");

      if (response.statusCode == 200) {
        debugPrint("Raw Response: ${response.body}");
        final data = jsonDecode(response.body);
        dataList = (data as List).map((item) {
          return item
              as Map<String, dynamic>; // Cast each item to Map<String, dynamic>
        }).toList();
      } else if (response.statusCode == 404) {
        debugPrint("Data not found");
        dataList = []; //no data
      } else {
        debugPrint("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
    return dataList;
  }

  // POST request
  Future<Map<String, dynamic>> postData(Map<String, dynamic> body) async {
    Map<String, dynamic> dataMap = {};
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        // Parse and return the response body
        dataMap = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint("Response from API (POST): ${dataMap['message']}");
      } else {
        // Handle non-201 status codes
        debugPrint(
          "Failed to post data. Status Code: ${response.statusCode}, Response: ${response.body}",
        );
      }
    } catch (e) {
      // Handle network or JSON parsing errors
      debugPrint("Error while posting data: $e");
    }
    return dataMap;
  }

  // DELETE request
  Future<bool> deleteData(String id) async {
    bool deleted = false;
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

      if (response.statusCode == 200) {
        deleted = true;
        debugPrint("Successfully deleted item with id: $id");
      } else {
        debugPrint(
          "Failed to delete data. Status Code: ${response.statusCode}, Response: ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("Error while deleting data: $e");
    }
    return deleted;
  }

  Future<int> authenticateLogin(String mobileNumber, String password) async {
    Map<String, dynamic> body = {
      "username": mobileNumber,
      "password": password
    };
    debugPrint("$body");
    int statusCode = 0;
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      debugPrint("${response.statusCode}");
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

  // PATCH request to update booking status
  Future<bool> updateBookingStatus(String id, String newStatus) async {
    bool isUpdated = false;
    try {
      final url = Uri.parse('$baseUrl/$id/status');
      Map<String, dynamic> body = {"Status": newStatus};

      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        isUpdated = true;
        debugPrint("Booking status updated successfully for ID: $id");
      } else if (response.statusCode == 400) {
        debugPrint("Invalid status provided.");
      } else if (response.statusCode == 404) {
        debugPrint("Room not found.");
      } else {
        debugPrint(
          "Failed to update booking status. Status Code: ${response.statusCode}, Response: ${response.body}",
        );
      }
    } catch (e) {
      debugPrint("Error while updating booking status: $e");
    }
    return isUpdated;
  }
}
