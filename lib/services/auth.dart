import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:savvy_aqua_delivery/constants/constant.dart';
import 'package:savvy_aqua_delivery/model/fuel_model.dart';
import 'package:savvy_aqua_delivery/model/maintenance_model.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
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

  static Future<List<FuelModel>> fuelList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.post(
        Uri.parse(Constant.viewFuel),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "driver_id": driverId,
        }),
      );
      if (kDebugMode) {
        print("Constant.addFuel ${Constant.viewFuel}");
        print("addFuel response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          List<dynamic> responseList = jsonresponse["details"];
          print(
              "-------------------------responseList:${responseList.toString()}");

          List<FuelModel> fuelList = responseList.map((data) {
            return FuelModel.fromJson(data);
          }).toList();
          return fuelList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Login Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<bool> addMaintenance(
      // String date,
      String vehicleNo,
      String maintenanceType,
      String maintenanceDesciption,
      String price) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.post(
        Uri.parse(Constant.storeMaintenance),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          // need to send date also
          "driver_id": driverId,

          "vehical_no": vehicleNo,
          "maintenance_type": maintenanceType,
          "maintenance_desciption": maintenanceDesciption,
          "total_amount": price
        }),
      );
      if (kDebugMode) {
        print("Constant.addFuel ${Constant.storeMaintenance}");
        print("addMaintenance response:${response.body}");
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

  static Future<List<MaintenanceModel>> maintenanceList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.post(
        Uri.parse(Constant.viewMaintenance),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "driver_id": driverId,
        }),
      );
      if (kDebugMode) {
        print("Constant.addFuel ${Constant.viewMaintenance}");
        print("addFuel response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          List<dynamic> responseList = jsonresponse["details"];
          print(
              "-------------------------responseList:${responseList.toString()}");

          List<MaintenanceModel> maintenanceList = responseList.map((data) {
            return MaintenanceModel.fromJson(data);
          }).toList();
          return maintenanceList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Login Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<List<OrderModel>> orderList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.post(
        Uri.parse(Constant.veiwAllOrder),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "driver_id": driverId,
          // "driver_id": "1",
        }),
      );
      if (kDebugMode) {
        print("Constant.addFuel ${Constant.veiwAllOrder}");
        print("addFuel response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          List<dynamic> responseList = jsonresponse["details"];
          print(
              "-------------------------responseList:${responseList.toString()}");

          List<OrderModel> orderList = responseList.map((data) {
            return OrderModel.fromJson(data);
          }).toList();
          return orderList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Login Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<bool> orderConfirmation(
    // String date,
    String orderId,
    String deliverQty,
    String returnQty,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.post(
        Uri.parse(Constant.confirmOrder),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "driver_id": driverId,
          "order_id": orderId,
          "delever_qty": deliverQty,
          "return_qty": returnQty
        }),
      );
      if (kDebugMode) {
        print("Constant.confirmOrder ${Constant.confirmOrder}");
        print("Confirm Order response:${response.body}");
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
        print("Confirm Order Error $e");
      }
      return false;
    }
    return false;
  }
}
