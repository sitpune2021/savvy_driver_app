import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:savvy_aqua_delivery/model/digital_card_model.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DigitalCard extends StatefulWidget {
  @override
  _DigitalCardState createState() => _DigitalCardState();
}

class _DigitalCardState extends State<DigitalCard> {
  List<DigitalCardModel> digitalCards = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDigitalCard();
  }

  Future<void> fetchDigitalCard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<DigitalCardModel> list = await Auth.fetchDigitalCard();
      setState(() {
        digitalCards = list;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching digital card data: $e");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          "Driver Digital Card",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    border: TableBorder.all(color: Colors.blue),
                    columns: const [
                      DataColumn(label: Text("Sr. No")),
                      DataColumn(label: Text("Date")),
                      DataColumn(label: Text("Customer Name")),
                      DataColumn(label: Text("No of full \nDelivered Jars")),
                      DataColumn(label: Text("No of \nempty Jars")),
                      // DataColumn(label: Text("Action")),
                    ],
                    rows: digitalCards.isEmpty
                        ? [
                            const DataRow(cells: [
                              DataCell(Text("No data available")),
                              DataCell(Text("-")),
                              DataCell(Text("-")),
                              DataCell(Text("-")),
                              DataCell(Text("-")),
                              // DataCell(Text("-")),
                            ])
                          ]
                        : digitalCards.asMap().entries.map((entry) {
                            int index = entry.key + 1;
                            DigitalCardModel item = entry.value;

                            return DataRow(cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Text(DateFormat("dd-MM-yyyy")
                                  .format(item.createdAt))),
                              DataCell(Text(item.customerName)),
                              DataCell(Text(item.deliverQty)),
                              DataCell(Text(item.returnQty)),
                              // DataCell(IconButton(
                              //   icon: const Icon(Icons.edit),
                              //   onPressed: () {
                              //     // Implement edit action
                              //   },
                              // )),
                            ]);
                          }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}
