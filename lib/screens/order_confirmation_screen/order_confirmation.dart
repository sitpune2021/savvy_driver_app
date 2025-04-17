import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:savvy_aqua_delivery/screens/dashboard_screen/dashboard_screen.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderConfirmation extends StatefulWidget {
  final String orderId;
  final String customerId;

  const OrderConfirmation(
      {super.key, required this.orderId, required this.customerId});

  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  final TextEditingController _deliveredItem = TextEditingController();
  final TextEditingController _returnedItem = TextEditingController();

  File? deliveredImage;
  File? returnedImage;

  void _submitForm() async {
    String returnedItem = _returnedItem.text.trim();
    String deliveredItem = _deliveredItem.text.trim();

    if (returnedItem.isEmpty || deliveredItem.isEmpty
        // deliveredImage == null ||
        // returnedImage == null
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    } else {
      bool result = await Auth.orderConfirmation(
          widget.customerId,
          widget.orderId,
          deliveredItem,
          returnedItem,
          deliveredImage,
          returnedImage);
      if (result) {
        _returnedItem.clear();
        _deliveredItem.clear();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future.delayed(const Duration(milliseconds: 500), () {
          prefs.setString("navTwo", "true");
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: DashboardScreen()),
            (route) => false,
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order submitted Successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Error please try again later!')),
        );
      }
    }
  }

  Future<void> _pickImage(bool isDelivered) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isDelivered) {
          deliveredImage = File(pickedFile.path);
        } else {
          returnedImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _pickImagenew(bool isDelivered) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      if (await Permission.photos.request().isGranted) {
        status = PermissionStatus.granted;
      } else if (await Permission.storage.request().isGranted) {
        status = PermissionStatus.granted;
      } else if (await Permission.mediaLibrary.request().isGranted) {
        status = PermissionStatus.granted;
      } else {
        status = PermissionStatus.denied;
      }
    } else {
      // iOS
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        setState(() {
          if (isDelivered) {
            deliveredImage = File(pickedFile.path);
          } else {
            returnedImage = File(pickedFile.path);
          }
        });
        print("************************deliveredImage$deliveredImage");
        print("************************returnedImage$returnedImage");
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Open settings if permanently denied
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Permission denied. Cannot access photos.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Order Confirmation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                  "Delivered Item", deliveredImage, _deliveredItem, true),
              const SizedBox(height: 20),
              _buildSection(
                  "Returned Bottle", returnedImage, _returnedItem, false),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, File? image,
      TextEditingController controller, bool isDelivered) {
    File? selectedPhoto = isDelivered ? deliveredImage : returnedImage;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 80, // Set a fixed width
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      label: const Text(
                        "count",
                        style: TextStyle(color: Colors.blue),
                      ),
                      hintText: "count", // Use count as initial value
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Colors.blue), // Default border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Colors.blue, width: 2), // Blue when focused
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () => _pickImagenew(isDelivered),
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                        image: image != null
                            ? DecorationImage(
                                image: FileImage(image), fit: BoxFit.cover)
                            : null,
                      ),
                      child: image == null
                          ? const Icon(Icons.add, size: 30, color: Colors.grey)
                          : null,
                    ),
                    if (selectedPhoto != null)
                      Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (isDelivered) {
                                  deliveredImage = null; // Reset meter photo
                                } else {
                                  returnedImage = null; // Reset receipt photo
                                }
                              });
                            },
                            icon: const Icon(Icons.close, color: Colors.red),
                          )),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          String returnedItem = _returnedItem.text.trim();
          String deliveredItem = _deliveredItem.text.trim();

          if (returnedItem.isEmpty || deliveredItem.isEmpty
              // deliveredImage == null ||
              // returnedImage == null
              ) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill all fields')),
            );
            return;
          }
          showConfirmationDialog(
              context, _deliveredItem.text.trim(), _returnedItem.text.trim());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text("Submit",
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  Future<void> showConfirmationDialog(
      BuildContext context, String deliveredItem, String receivedItem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Order Confirmation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Delivered Items: $deliveredItem",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Received Items: $receivedItem",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Delete Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      _submitForm();
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Not Now Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
