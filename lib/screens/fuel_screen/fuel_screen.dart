import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/model/fuel_model.dart';
import 'package:savvy_aqua_delivery/screens/fuel_screen/fuel_details_screen/fuel_details.dart';
import 'package:savvy_aqua_delivery/screens/fuel_screen/fueling_form/fuel_form.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';

class FuelScreen extends StatefulWidget {
  const FuelScreen({super.key});

  @override
  State<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends State<FuelScreen> {
  DateTime? fromDate;
  DateTime? toDate;
  List<FuelModel> allFuelData = []; // Stores all data fetched from Firebase
  List<FuelModel> filteredFuelData =
      []; // Stores filtered data based on date range

  @override
  void initState() {
    super.initState();
    _fetchFuelData();
  }

  Future<void> _fetchFuelData() async {
    try {
      List<FuelModel> data = await Auth.fuelList();
      setState(() {
        allFuelData = data;
        filteredFuelData = data; // Initially show all data
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void _filterData() {
    if (fromDate == null || toDate == null) return;

    setState(() {
      filteredFuelData = allFuelData.where((fuel) {
        // Convert string date to DateTime
        DateTime fuelDate = DateFormat("dd-MM-yyyy").parse(fuel.date);

        return fuelDate.isAfter(fromDate!.subtract(const Duration(days: 1))) &&
            fuelDate.isBefore(toDate!.add(const Duration(days: 1)));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Fueling List",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: const FuelForm()),
          );

          if (result == true) {
            _fetchFuelData(); // Refresh list when returning from FuelForm
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: _fetchFuelData,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildDateFilter(),
              const SizedBox(height: 12),
              Expanded(child: _buildFuelList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateField("From Date", fromDate, true),
        const SizedBox(width: 5),
        _buildDateField("To Date", toDate, false),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: _filterData, // Filter the list when Search is clicked
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

  Widget _buildFuelList() {
    return filteredFuelData.isEmpty
        ? const Center(child: Text("No Data Available"))
        : ListView.builder(
            itemCount: filteredFuelData.length,
            itemBuilder: (context, index) {
              final item = filteredFuelData[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: FuelDetails(
                        date: item.date,
                        vehicleNo: item.vehicleNo,
                        totalFuel: item.totalFuel,
                        price: item.price,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.vehicleNo,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Row(
                        children: [
                          const Icon(Icons.local_gas_station,
                              color: Colors.blue),
                          const SizedBox(width: 5),
                          Text(item.totalFuel,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500)),
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
}
