import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStatusProvider extends ChangeNotifier {
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  void updateAdminStatus(bool status) {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isAdmin', status);
    _isAdmin = status;
    notifyListeners();
  }
}
