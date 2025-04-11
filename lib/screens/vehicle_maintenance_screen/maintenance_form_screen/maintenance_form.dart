import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:savvy_aqua_delivery/services/auth.dart';

class MaintenanceForm extends StatefulWidget {
  const MaintenanceForm({super.key});

  @override
  State<MaintenanceForm> createState() => _MaintenanceFormState();
}

class _MaintenanceFormState extends State<MaintenanceForm> {
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _maintenanceTypeController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();

  File? _billImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _billImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImagenew() async {
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
          _billImage = File(pickedFile.path);
        });

        print("************************_billImage$_billImage");
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

  void _submitForm() async {
    String vehicleNumber = _vehicleNumberController.text.trim();
    String maintenanceType = _maintenanceTypeController.text.trim();
    String description = _descriptionController.text.trim();
    String totalAmount = _totalAmountController.text.trim();

    if (vehicleNumber.isEmpty ||
        maintenanceType.isEmpty ||
        description.isEmpty ||
        totalAmount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    } else {
      bool result = await Auth.addMaintenance(
          vehicleNumber, maintenanceType, description, totalAmount, _billImage);

      if (result) {
        _vehicleNumberController.clear();
        _maintenanceTypeController.clear();
        _descriptionController.clear();
        _totalAmountController.clear();
        // Add a delay of 1 second before navigating
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context, true);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Maintenance Form Submitted Successfully')),
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
          "Maintenance Form",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Vehicle Number"),
                  _buildTextField(_vehicleNumberController, "Enter Number"),
                  _buildLabel("Maintenance Type"),
                  _buildTextField(_maintenanceTypeController, "Enter Type"),
                  _buildLabel("Description"),
                  _buildTextField(_descriptionController, "Enter Description"),
                  _buildLabel("Total Amount"),
                  _buildTextField(_totalAmountController, "Enter Amount"),
                  const Divider(),
                  _buildLabel("Bill"),
                  GestureDetector(
                    onTap: _pickImagenew,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Upload Photo"),
                          SizedBox(width: 8),
                          Icon(Icons.upload, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  if (_billImage != null)
                    Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade400),
                                image: _billImage != null
                                    ? DecorationImage(
                                        image: FileImage(_billImage!),
                                        fit: BoxFit.cover)
                                    : null,
                              ),
                              child: _billImage == null
                                  ? const Icon(Icons.add,
                                      size: 30, color: Colors.grey)
                                  : null,
                            ),
                            if (_billImage != null)
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_billImage != null) {
                                          _billImage =
                                              null; // Reset meter photo
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.close,
                                        color: Colors.red),
                                  )),
                          ],
                        )),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
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

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
