import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:savvy_aqua_delivery/constants/constant.dart';
import 'package:savvy_aqua_delivery/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static Future<bool> login(String mobileno) async {
    try {
      final response = await http.post(
        Uri.parse(Constant.login),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'mobile_no': mobileno,
        }),
      );
      if (kDebugMode) {
        print("Constant.login ${Constant.login}");
        print("Login response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          UserModel user = UserModel.fromJson(jsonresponse['details']);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userid", user.userId);
          prefs.setString("otp", user.otp);
          prefs.setString("name", user.name);
          prefs.setString("email", user.username);
          prefs.setString("phone", user.phone);
          final otp = prefs.getString("otp");
          print("-------------------- Auth model otp ${user.otp}");
          print("-------------------- Auth local storage otp ${otp}");
          if (kDebugMode) {
            print("-------------------- User details: ${user.name}");
          }
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Login Error $e");
      }
      return false;
    }
    return false;
  }

  static Future<bool> addFuel(
      String date, String vehicleNo, String price, String totalFuel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.post(
        Uri.parse(Constant.addFuel),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "driver_id": driverId,
          "date": date,
          "vehical_no": vehicleNo,
          "price": price,
          "total_fule": totalFuel
        }),
      );
      if (kDebugMode) {
        print("Constant.addFuel ${Constant.addFuel}");
        print("addFuel response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Login Error $e");
      }
      return false;
    }
    return false;
  }
}
