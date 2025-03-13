import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/model/maintenance_model.dart';
import 'package:savvy_aqua_delivery/screens/vehicle_maintenance_screen/maintenance_details_screen/maintenance_details.dart';
import 'package:savvy_aqua_delivery/screens/vehicle_maintenance_screen/maintenance_form_screen/maintenance_form.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';

class VehicleMaintenance extends StatefulWidget {
  @override
  _VehicleMaintenanceState createState() => _VehicleMaintenanceState();
}

class _VehicleMaintenanceState extends State<VehicleMaintenance> {
  DateTime? fromDate;
  DateTime? toDate;
  List<MaintenanceModel> allMaintenanceList = [];
  List<MaintenanceModel> filteredMaintenanceList =
      []; // Stores filtered data based on date range
  bool isLoading = true;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
  void initState() {
    super.initState();
    _fetchMaintenanceList();
  }

  Future<void> _fetchMaintenanceList() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<MaintenanceModel> list = await Auth.maintenanceList();
      setState(() {
        allMaintenanceList = list;
        filteredMaintenanceList = list;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching maintenance list: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterData() {
    if (fromDate == null || toDate == null) {
      return;
    } else if (fromDate!.isAfter(toDate!)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter correct dates!")));
    } else {
      setState(() {
        filteredMaintenanceList = allMaintenanceList.where((maintenance) {
          // Convert string date to DateTime
          DateTime maintenanceDate =
              DateFormat("yyyy-MM-dd").parse(maintenance.createdAt);

          return maintenanceDate
                  .isAfter(fromDate!.subtract(const Duration(days: 1))) &&
              maintenanceDate.isBefore(toDate!.add(const Duration(days: 1)));
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: const Text("Maintenance List",
            style: TextStyle(color: Colors.white)),
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 8.0),
        //     child: ElevatedButton(
        //       onPressed: () {},
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: Colors.white,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //       ),
        //       child:
        //           Text("Vehicle M - +", style: TextStyle(color: Colors.blue)),
        //     ),
        //   )
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "ADD",
        backgroundColor: Colors.blue,
        onPressed: () async {
          bool? result = await Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  child: const MaintenanceForm()));

          if (result == true) {
            _fetchMaintenanceList();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDateField(context, "From Date", fromDate, true),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDateField(context, "To Date", toDate, false),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _filterData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  child: const Text("Search",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.blue,
                    )) // <-- Show loading spinner
                  : filteredMaintenanceList.isEmpty
                      ? const Center(child: Text("No Data Available"))
                      : ListView.builder(
                          itemCount:
                              filteredMaintenanceList.length, // Example count
                          itemBuilder: (context, index) {
                            final data = filteredMaintenanceList[index];

                            return GestureDetector(
                                onTap: () async {
                                  bool? result = await Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          child: MaintenanceDetails(
                                            vehicleNo: data.vehicleNo,
                                            maintenanceType:
                                                data.maintenanceType,
                                            maintenanceDescription:
                                                data.maintenanceDescription,
                                            totalAmount: data.totalAmount,
                                            createdAt: data.createdAt,
                                          )));

                                  if (result == true) {
                                    setState(() {});
                                  }
                                },
                                child: MaintenanceCard(
                                  vehicleNo: data.vehicleNo,
                                  maintenanceType: data.maintenanceType,
                                  maintenanceDescription:
                                      data.maintenanceDescription,
                                  totalAmount: data.totalAmount,
                                ));
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context, String label, DateTime? date, bool isFromDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isFromDate),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date != null ? DateFormat('dd-MM-yyyy').format(date) : label,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class MaintenanceCard extends StatefulWidget {
  final String vehicleNo;
  final String maintenanceType;
  final String maintenanceDescription;
  final String totalAmount;

  const MaintenanceCard(
      {super.key,
      required this.vehicleNo,
      required this.maintenanceType,
      required this.maintenanceDescription,
      required this.totalAmount});

  @override
  State<MaintenanceCard> createState() => _MaintenanceCardState();
}

class _MaintenanceCardState extends State<MaintenanceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextRow("Vehicle Number", widget.vehicleNo),
            _buildTextRow("Maintenance Type", widget.maintenanceType),
            _buildTextRow("Description", widget.maintenanceDescription),
            const SizedBox(height: 8),
            const Text("Bill",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.insert_drive_file,
                          color: Colors.blue, size: 30),
                      Text("PNG",
                          style: TextStyle(color: Colors.blue, fontSize: 14)),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextRow("Total", widget.totalAmount,
                        valueColor: Colors.blue),
                    _buildTextRow("Status", "Approved",
                        valueColor: Colors.green),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextRow(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: "$title - ",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: valueColor ?? Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
