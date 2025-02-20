import 'package:crc_app/userStatusProvider/db_keys_room_status.dart';
import 'package:flutter/material.dart';

class UserStatusProvider extends ChangeNotifier {
  bool _isAdmin = false;
  List<Map<String, dynamic>> _userEventData = [];

  bool get isAdmin => _isAdmin;
  // Getter for event data
  List<Map<String, dynamic>> get userEventData => _userEventData;

  void updateAdminStatus(bool status) {
    _isAdmin = status;
    notifyListeners();
  }

  List<Map<String, dynamic>> getAllData() {
    return _userEventData;
  }

  //events functions
  // Method to assign a new list to userEventData
  void setEventDataList(List<Map<String, dynamic>> eventData) {
    _userEventData = eventData;
    notifyListeners();
  }

  // Method to add a map to the list
  void addEventData(Map<String, dynamic> event) {
    _userEventData.add(event);
    notifyListeners();
  }

  // Method to delete a map by its "id" key
  void deleteEventDataById(String id) {
    _userEventData.removeWhere((event) => event[DBKeys.id] == id);
    notifyListeners();
  }

  // Method to update the "status" of a map by its "id"
  void updateEventStatusById(String id, dynamic status) {
    bool updated = false;
    int length = _userEventData.length;
    for (int i = 0; i < length && !updated; i++) {
      if (_userEventData[i][DBKeys.id] == id) {
        _userEventData[i][DBKeys.status] = status;
        updated = true;
      }
    }
    // Notify listeners only if an update occurred
    if (updated) {
      notifyListeners();
    }
  }

  void clearEvents() {
    _userEventData.clear();
    notifyListeners();
  }
}
