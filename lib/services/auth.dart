import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
          'phone_no': mobileno,
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

        if (jsonresponse['status'] == true) {
          String phoneno = jsonresponse["data"]["phone_no"];
          // UserModel user = UserModel.fromJson(jsonresponse['details']);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString("userid", user.userId);
          // prefs.setString("otp", user.otp);
          // prefs.setString("name", user.name);
          // prefs.setString("email", user.username);
          prefs.setString("loginPhoneNo", phoneno);
          // final otp = prefs.getString("otp");
          // print("-------------------- Auth model otp ${user.otp}");
          // print("-------------------- Auth local storage otp ${otp}");
          if (kDebugMode) {
            // print("-------------------- User details: ${user.name}");
            print(
                "-------------------- User details:not found here:- true$phoneno");
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

  static Future<bool> verifyOtp(String otp) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final mobileno = prefs.getString("loginPhoneNo");
      final response = await http.post(
        Uri.parse(Constant.verifyOtp),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{'phone_no': mobileno, "otp": otp}),
      );
      if (kDebugMode) {
        print("Constant.verfiyOtp ${Constant.verifyOtp}");
        print("verifyOtp response:${response.body}");
        // return true;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == true) {
          String token = jsonresponse["data"]["token"].toString();
          UserModel user = UserModel.fromJson(jsonresponse['data']["driver"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userid", user.userId);
          prefs.setString("token", token);
          prefs.setString("name", user.name);
          prefs.setString("email", user.username);
          prefs.setString("phone", user.phone);
          final otp = prefs.getString("name");
          print("-------------------- Auth model otp ${user.name}");
          print("-------------------- Auth local storage otp ${otp}");
          if (kDebugMode) {
            print("-------------------- User details: ${user.name}");
            print("-------------------- User details:not found here:- true");
          }
          return true;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("otp Error $e");
      }
      return false;
    }
    return false;
  }

  static Future<bool> addFuel(
    String date,
    // String vehicleNo,
    String price,
    String totalFuel,
    File? meterPhoto,
    File? receiptPhoto,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      String? token = prefs.getString("token");
      if (kDebugMode) {
        print("--------------------------token: $token");
      }
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }

      var request = http.MultipartRequest("POST", Uri.parse(Constant.addFuel));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      // Add form fields
      request.fields['driver_id'] = driverId ?? "";
      request.fields['date'] = date;
      request.fields['type'] = "fuel";
      request.fields['amount'] = price;
      request.fields['description'] = totalFuel;

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

        if (jsonresponse['status'] == true) {
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
      String? token = prefs.getString("token");
      if (kDebugMode) {
        print("--------------------------token: $token");
      }
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.get(
        Uri.parse(
            "${Constant.viewFuel}maintenance?driver_id=$driverId&type=fuel"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode(<String, dynamic>{
        //   "driver_id": driverId,
        // }),
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

        if (jsonresponse['status'] == true) {
          List<dynamic> responseList = jsonresponse["data"];
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
      // String vehicleNo,
      // String maintenanceType,
      String maintenanceDesciption,
      String price,
      File? imageFile,
      String date) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      String? token = prefs.getString("token");
      if (kDebugMode) {
        print("--------------------------token: $token");
      }
      var request =
          http.MultipartRequest("POST", Uri.parse(Constant.storeMaintenance));
      // Add text fields
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type':
            'multipart/form-data', // i have to check using this if image is uploading or not
      });
      request.fields['driver_id'] = driverId ?? "";
      // request.fields['vehical_no'] = vehicleNo;
      request.fields['type'] = "other";
      request.fields['description'] = maintenanceDesciption;
      request.fields['amount'] = price;
      request.fields['date'] = date;

      // Add image file if exists
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
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

        if (jsonresponse['status'] == true) {
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
      String? token = prefs.getString("token");
      if (kDebugMode) {
        print("--------------------------token: $token");
      }
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.get(
        Uri.parse(
            "${Constant.viewMaintenance}maintenance?driver_id=$driverId&type=other"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        // body: jsonEncode(<String, dynamic>{
        //   "driver_id": driverId,
        // }),
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

        if (jsonresponse['status'] == true) {
          List<dynamic> responseList = jsonresponse["data"];
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
      String? token = prefs.getString("token");
      if (kDebugMode) {
        print("--------------------------token: $token");
      }
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.get(
        Uri.parse(
            "${Constant.veiwAllOrder}order?driver_id=$driverId&status=pending"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode(<String, dynamic>{
        //   "driver_id": driverId,
        //   "status": "pending"

        //   // "driver_id": "1",
        // }),
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

        if (jsonresponse['status'] == true) {
          List<dynamic> responseList = jsonresponse["data"];
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
      String? token = prefs.getString("token");
      if (kDebugMode) {
        print("--------------------------token: $token");
      }
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.get(
        Uri.parse(
            "${Constant.veiwAllOrder}order?status=completed&driver_id=$driverId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode(<String, dynamic>{
        //   "driver_id": driverId,
        //   "status": "completed"
        //   // "driver_id": "1",
        // }),
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

        if (jsonresponse['status'] == true) {
          List<dynamic> responseList = jsonresponse["data"];
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
    String customerId,
    String orderId,
    String deliverQty,
    String returnQty,
    File? deliveredItem,
    File? receivedItem,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      String? token = prefs.getString("token");
      if (kDebugMode) {
        print("--------------------------token: $token");
      }
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }

      var request = http.MultipartRequest(
          "POST", Uri.parse("${Constant.confirmOrder}order_update/$orderId"));
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
      request.fields['driver_id'] = driverId ?? "";
      request.fields['customer_id'] = customerId;
      request.fields['develivered_qty'] = deliverQty;
      request.fields['return_qty'] = returnQty;
      request.fields['status'] = "completed";

      // Attach images if available
      if (deliveredItem != null) {
        print("Delivered item path: ${deliveredItem.path}");
        print("Delivered item exists: ${await deliveredItem.exists()}");
        print("Delivered item path: ${receivedItem!.path}");
        print("Delivered item exists: ${await receivedItem.exists()}");
        // request.files.add(
        //   await http.MultipartFile.fromPath(
        //     'delevered_card_img',
        //     deliveredItem.path,
        //   ),
        // );
        http.MultipartFile.fromPath(
          'delivered_card_img',
          deliveredItem.path,
          contentType: MediaType('image', 'jpg'), // This is now recognized
        );
      }
      if (receivedItem != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
              'return_card_img', receivedItem.path),
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

        if (jsonresponse['status'] == true) {
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
      String? token = prefs.getString("token");
      if (kDebugMode) {
        print("--------------------------token: $token");
      }
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.get(
        Uri.parse(
            "${Constant.digitalCard}order?status=completed&driver_id=$driverId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        // body: jsonEncode(<String, dynamic>{
        //   "driver_id": driverId,
        //   // "driver_id": "1",

        // }),
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

        if (jsonresponse['status'] == true) {
          List<dynamic> responseList = jsonresponse["data"];
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

  static Future<Map<String, dynamic>?> orderDetails(String orderId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      String? token = prefs.getString("token");

      if (kDebugMode) {
        print("--------------------------token: $token");
        print("--------------------------driverid: $driverId");
      }

      final response = await http.get(
        Uri.parse("${Constant.orderDetails}order/$orderId?driver_id=$driverId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (kDebugMode) {
        print("Constant.orderDetails ${Constant.orderDetails}");
        print("orderDetails response: ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (kDebugMode) {
          print("jsonresponse: $jsonresponse");
        }

        if (jsonresponse['status'] == true) {
          Map<String, dynamic> orderData = jsonresponse["data"];
          return orderData;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("OrderDetails Error: $e");
      }
      return null;
    }

    return null;
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
