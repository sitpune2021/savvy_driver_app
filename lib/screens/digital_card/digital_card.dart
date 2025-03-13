import 'package:flutter/material.dart';

class DigitalCard extends StatefulWidget {
  @override
  _DigitalCardState createState() => _DigitalCardState();
}

class _DigitalCardState extends State<DigitalCard> {
  List<Map<String, String>> data = List.generate(
    22,
    (index) => {
      "srNo": "${index + 1}",
      "date": "12-03-2025",
      "deliveredJars": "10",
      "receivedJars": "10",
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Driver Digital Card",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              border: TableBorder.all(color: Colors.blue),
              columns: const [
                DataColumn(label: Text("Sr. No")),
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("No of full \nDelivered Jars")),
                DataColumn(label: Text("No of \nempty Jars")),
                DataColumn(label: Text("Action")),
              ],
              rows: data.map((item) {
                return DataRow(cells: [
                  DataCell(Text(item["srNo"]!)),
                  DataCell(Text(item["date"]!)),
                  DataCell(Text(item["deliveredJars"]!)),
                  DataCell(Text(item["receivedJars"]!)),
                  const DataCell(Icon(Icons.edit)),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
