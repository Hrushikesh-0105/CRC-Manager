import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.137.121:5500/booking';

  // GET request
  Future<List<dynamic>?> getData(String roomName, String date) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/all?roomName=$roomName&date=$date'));
      print("${response.statusCode}");

      if (response.statusCode == 200) {
        print("Raw Response: ${response.body}");

        final List<dynamic> data = jsonDecode(response.body);
        print("Decoded Response: $data");

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
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("hello");
      print("Error: $e");
    }
  }

  // POST request
  Future<void> postData(Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create/data'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Response from API (POST): ${data['message']}");
      } else {
        print("Failed to post data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // DELETE request
  Future<void> deleteData(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/data/$id'));

      if (response.statusCode == 200) {
        print("Successfully deleted item with id: $id");
      } else {
        print("Failed to delete data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
