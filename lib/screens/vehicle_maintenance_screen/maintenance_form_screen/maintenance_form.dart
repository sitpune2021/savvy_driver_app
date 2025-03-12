import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  void _submitForm() {
    String vehicleNumber = _vehicleNumberController.text;
    String maintenanceType = _maintenanceTypeController.text;
    String description = _descriptionController.text;
    String totalAmount = _totalAmountController.text;

    if (vehicleNumber.isEmpty ||
        maintenanceType.isEmpty ||
        description.isEmpty ||
        totalAmount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Handle form submission logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form Submitted Successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                  _buildTextField(_maintenanceTypeController, "Edit Text"),
                  _buildLabel("Description"),
                  _buildTextField(_descriptionController, "Enter Description"),
                  _buildLabel("Total Amount"),
                  _buildTextField(_totalAmountController, "Enter Amount"),
                  const Divider(),
                  _buildLabel("Bill"),
                  GestureDetector(
                    onTap: _pickImage,
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
                      child: Image.file(_billImage!, height: 100),
                    ),
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
                  shape: RoundedRectangleBorder(
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
