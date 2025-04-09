import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:savvy_aqua_delivery/constants/constant.dart';
import 'package:savvy_aqua_delivery/model/digital_card_model.dart';
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
    String date,
    String vehicleNo,
    String price,
    String totalFuel,
    File? meterPhoto,
    File? receiptPhoto,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");

      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }

      var request = http.MultipartRequest("POST", Uri.parse(Constant.addFuel));

      // Add form fields
      request.fields['driver_id'] = driverId ?? "";
      request.fields['date'] = date;
      request.fields['vehical_no'] = vehicleNo;
      request.fields['price'] = price;
      request.fields['total_fule'] = totalFuel;

      // Attach images if available
      if (meterPhoto != null) {
        print("📷 Meter Photo Path: ${meterPhoto.path}");
        request.files.add(await http.MultipartFile.fromPath(
            'file', // This should match your API parameter name
            meterPhoto.path));
      }

      if (receiptPhoto != null) {
        print("📷 Receipt Photo Path: ${receiptPhoto.path}");
        request.files.add(await http.MultipartFile.fromPath(
          'file1', // This should match your API parameter name
          receiptPhoto.path,
        ));
      }

      // Send request
      var response = await request.send();

      // Read response
      var responseBody = await response.stream.bytesToString();
      if (kDebugMode) {
        print("addFuel response: $responseBody");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(responseBody);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("addFuel Error: $e");
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

  // static Future<bool> addMaintenance(
  //     // String date,
  //     String vehicleNo,
  //     String maintenanceType,
  //     String maintenanceDesciption,
  //     String price) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? driverId = prefs.getString("userid");
  //     if (kDebugMode) {
  //       print("--------------------------driverid: $driverId");
  //     }
  //     final response = await http.post(
  //       Uri.parse(Constant.storeMaintenance),
  //       headers: <String, String>{'Content-Type': 'application/json'},
  //       body: jsonEncode(<String, dynamic>{
  //         // need to send date also
  //         "driver_id": driverId,

  //         "vehical_no": vehicleNo,
  //         "maintenance_type": maintenanceType,
  //         "maintenance_desciption": maintenanceDesciption,
  //         "total_amount": price
  //       }),
  //     );
  //     if (kDebugMode) {
  //       print("Constant.addFuel ${Constant.storeMaintenance}");
  //       print("addMaintenance response:${response.body}");
  //       // return true;
  //     }

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final jsonresponse = jsonDecode(response.body);
  //       if (kDebugMode) {
  //         print("jsonresponse: $jsonresponse");
  //       }

  //       if (jsonresponse['status'] == "success") {
  //         return true;
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Login Error $e");
  //     }
  //     return false;
  //   }
  //   return false;
  // }

  static Future<bool> addMaintenance(
    // String date,
    String vehicleNo,
    String maintenanceType,
    String maintenanceDesciption,
    String price,
    File? imageFile,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      var request =
          http.MultipartRequest("POST", Uri.parse(Constant.storeMaintenance));
      // Add text fields
      request.fields['driver_id'] = driverId ?? "";
      request.fields['vehical_no'] = vehicleNo;
      request.fields['maintenance_type'] = maintenanceType;
      request.fields['maintenance_desciption'] = maintenanceDesciption;
      request.fields['total_amount'] = price;

      // Add image file if exists
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('file', imageFile.path));
      }

      // Send request
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (kDebugMode) {
        print("Response Code: ${response.statusCode}");
        print("Response Body: $responseString");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(responseString);
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
          "status": "pending"
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
        print("ongoing orders Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<List<OrderModel>> completedOrderList() async {
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
          "status": "completed"
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
    String orderId,
    String deliverQty,
    String returnQty,
    File? deliveredItem,
    File? receivedItem,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");

      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }

      var request =
          http.MultipartRequest("POST", Uri.parse(Constant.confirmOrder));
      request.fields['driver_id'] = driverId ?? "";
      request.fields['order_id'] = orderId;
      request.fields['delever_qty'] = deliverQty;
      request.fields['return_qty'] = returnQty;

      // Attach images if available
      if (deliveredItem != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
              'deliveredItem', deliveredItem.path),
        );
      }
      if (receivedItem != null) {
        request.files.add(
          await http.MultipartFile.fromPath('reveivedItem', receivedItem.path),
        );
      }

      // var streamedResponse = await request.send();
      // var response = await http.Response.fromStream(streamedResponse);
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (kDebugMode) {
        print("Constant.confirmOrder ${Constant.confirmOrder}");
        print("Confirm Order response: ${responseString}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(responseString);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == "success") {
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Confirm Order Error: $e");
      }
      return false;
    }
    return false;
  }

  static Future<List<DigitalCardModel>> fetchDigitalCard() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.post(
        Uri.parse(Constant.digitalCard),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          "driver_id": driverId,
          // "driver_id": "1",
        }),
      );
      if (kDebugMode) {
        print("Constant.digitalCard ${Constant.digitalCard}");
        print("digitalCard response:${response.body}");
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

          List<DigitalCardModel> digitalCardList = responseList.map((data) {
            return DigitalCardModel.fromJson(data);
          }).toList();
          return digitalCardList;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("digitalCard Error $e");
      }
      return [];
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> orderDetails(String orderId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.post(
        Uri.parse(Constant.orderDetails),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            <String, dynamic>{"driver_id": driverId, "order_id": orderId}),
      );
      if (kDebugMode) {
        print("Constant.orderDetails ${Constant.orderDetails}");
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

          List<Map<String, dynamic>> orderDetailsList =
              responseList.cast<Map<String, dynamic>>();
          return orderDetailsList;
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

  static Future<bool> deleteAccount() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.post(
        Uri.parse(Constant.deleteAccount),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{"driver_id": driverId}),
      );
      if (kDebugMode) {
        print("Constant.deleteAccount ${Constant.deleteAccount}");
        print("deleteAccount response:${response.body}");
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
        print("Delete Account Error $e");
      }
      return false;
    }
    return false;
  }
}
