import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/screens/fuel_screen/fuel_details_screen/fuel_details.dart';
import 'package:savvy_aqua_delivery/screens/fuel_screen/fueling_form/fuel_form.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  DateTime? fromDate;
  DateTime? toDate;

  final List<Map<String, String>> fuelData = [
    {"vehicle": "MH 12 -6997", "liters": "10ltr"},
    {"vehicle": "MH 12 -6997", "liters": "20ltr"},
    {"vehicle": "MH 12 -6997", "liters": "15ltr"},
    {"vehicle": "MH 12 -6997", "liters": "10ltr"},
    {"vehicle": "MH 12 -6997", "liters": "15ltr"},
    {"vehicle": "MH 12 -6997", "liters": "13ltr"},
    {"vehicle": "MH 12 -6799", "liters": "12ltr"},
    {"vehicle": "MH 12 -6799", "liters": "20ltr"},
    {"vehicle": "MH 12 -6799", "liters": "12ltr"},
    {"vehicle": "MH 12 -6799", "liters": "14ltr"},
    {"vehicle": "MH 12 -6799", "liters": "12ltr"},
  ];

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "Fueling List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        //     onPressed: () {
        //       // Handle adding a new fueling record
        //     },
        //   ),
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const FuelForm()));
        },
        tooltip: "ADD",
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDateFilter(),
            const SizedBox(height: 12),
            Expanded(child: _buildFuelList()),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateField("From Date", fromDate, true),
        const SizedBox(
          width: 5,
        ),
        _buildDateField("To Date", toDate, false),
        const SizedBox(
          width: 5,
        ),
        ElevatedButton(
          onPressed: () {
            // Handle search functionality
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text("Search", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isFromDate) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDate(context, isFromDate),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date != null ? DateFormat('dd-MM-yyyy').format(date) : label,
                style:
                    TextStyle(color: date == null ? Colors.grey : Colors.black),
              ),
              const Icon(Icons.calendar_today, color: Colors.blue, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuelList() {
    return ListView.builder(
      itemCount: fuelData.length,
      itemBuilder: (context, index) {
        final item = fuelData[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const FuelDetails()));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item["vehicle"]!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    const Icon(Icons.local_gas_station, color: Colors.blue),
                    const SizedBox(width: 5),
                    Text(
                      item["liters"]!,
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
