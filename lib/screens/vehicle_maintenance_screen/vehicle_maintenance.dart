import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/screens/vehicle_maintenance_screen/maintenance_details_screen/maintenance_details.dart';
import 'package:savvy_aqua_delivery/screens/vehicle_maintenance_screen/maintenance_form_screen/maintenance_form.dart';

class VehicleMaintenance extends StatefulWidget {
  @override
  _VehicleMaintenanceState createState() => _VehicleMaintenanceState();
}

class _VehicleMaintenanceState extends State<VehicleMaintenance> {
  DateTime? fromDate;
  DateTime? toDate;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: Text("Maintenance List", style: TextStyle(color: Colors.white)),
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
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  child: MaintenanceForm()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildDateField(context, "From Date", fromDate, true),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildDateField(context, "To Date", toDate, false),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text("Search", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 2, // Example count
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 200),
                                child: MaintenanceDetails()));
                      },
                      child: MaintenanceCard());
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            Icon(Icons.calendar_today, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class MaintenanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextRow("Vehicle Number", "MH 12 6977"),
            _buildTextRow("Maintenance Type", "Break Failed"),
            _buildTextRow("Description", "Break Failed"),
            SizedBox(height: 8),
            Text("Bill",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.insert_drive_file,
                          color: Colors.blue, size: 30),
                      Text("PNG",
                          style: TextStyle(color: Colors.blue, fontSize: 14)),
                    ],
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextRow("Total", "2000", valueColor: Colors.blue),
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
      padding: EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: "$title - ",
          style: TextStyle(
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
