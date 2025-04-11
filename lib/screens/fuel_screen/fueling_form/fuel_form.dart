import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:savvy_aqua_delivery/screens/fuel_screen/fuel_screen.dart';
import 'dart:io';

import 'package:savvy_aqua_delivery/services/auth.dart';

class FuelForm extends StatefulWidget {
  const FuelForm({super.key});

  @override
  State<FuelForm> createState() => _FuelFormState();
}

class _FuelFormState extends State<FuelForm> {
  DateTime? selectedDate;
  File? meterPhoto;
  File? receiptPhoto;
  String? selectedDate2;

  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _fuelAmountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedDate2 = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  Future<void> _pickImagenew(bool isMeterPhoto) async {
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
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          if (isMeterPhoto) {
            meterPhoto = File(pickedFile.path);
          } else {
            receiptPhoto = File(pickedFile.path);
          }
        });

        print("************************meterPhoto$meterPhoto");
        print("************************receiptPhoto$receiptPhoto");
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

  Future<void> _pickImage(bool isMeterPhoto) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isMeterPhoto) {
          meterPhoto = File(pickedFile.path);
        } else {
          receiptPhoto = File(pickedFile.path);
        }
      });
    }
  }

  void _submitForm() async {
    if (selectedDate == null ||
        _vehicleNumberController.text.isEmpty ||
        _fuelAmountController.text.isEmpty ||
        _priceController.text.isEmpty ||
        meterPhoto == null ||
        receiptPhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and upload images')),
      );
      return;
    } else {
      bool result = await Auth.addFuel(
          selectedDate2.toString(),
          _vehicleNumberController.text.trim(),
          _priceController.text.trim(),
          _fuelAmountController.text.trim(),
          meterPhoto,
          receiptPhoto);

      if (result) {
        _vehicleNumberController.clear();
        _priceController.clear();
        _fuelAmountController.clear();
        // Add a delay of 1 second before navigating
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context, true);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fueling Form Submitted Successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Error please try again later!')),
        );
      }
    }

    // Handle form submission logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          "Fueling Form",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildFormContainer(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Enter Date"),
                  _buildDateField("Enter Date"),
                ],
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Vehicle Number"),
                  _buildTextField(_vehicleNumberController, "Vehicle Number"),
                ],
              )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Price"),
                  _buildTextField(_priceController, "Price"),
                ],
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Total Fuel(Ltr)"),
                  _buildTextField(_fuelAmountController, "Total Fuel(Ltr)"),
                ],
              )),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Meter Photo"),
                  _buildUploadButton("Meter Photo", true),
                ],
              )),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Receipt"),
                  _buildUploadButton("Receipt", false),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate == null
                  ? "DD/MM/YY"
                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              style: TextStyle(
                  color: selectedDate == null ? Colors.grey : Colors.black),
            ),
            const Icon(Icons.calendar_today, color: Colors.blue, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintStyle:
            const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
        hintText: hintText,
        border: OutlineInputBorder(
          // Use OutlineInputBorder instead of BoxDecoration
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Colors.blue), // Default border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: Colors.blue, width: 2), // Blue when focused
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildUploadButton(String label, bool isMeterPhoto) {
    File? selectedPhoto = isMeterPhoto ? meterPhoto : receiptPhoto;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickImagenew(isMeterPhoto),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(color: Colors.black)),
                const Icon(Icons.upload, color: Colors.blue, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (selectedPhoto != null) // Show image preview if a photo is selected
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(selectedPhoto),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (isMeterPhoto) {
                          meterPhoto = null; // Reset meter photo
                        } else {
                          receiptPhoto = null; // Reset receipt photo
                        }
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.red),
                  )),
            ],
          )
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Submit",
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
