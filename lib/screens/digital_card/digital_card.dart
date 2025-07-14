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
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchDigitalCard(page: 1);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!_isLoadingMore && _hasMoreData) {
          fetchDigitalCard(page: _currentPage + 1);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchDigitalCard({int page = 1}) async {
    if (_isLoadingMore || !_hasMoreData) return;

    if (page == 1) {
      setState(() => _isLoading = true);
    } else {
      setState(() => _isLoadingMore = true);
    }

    try {
      final response = await Auth.fetchDigitalCardPage(page);
      final List<DigitalCardModel> cards = response['cards'];
      final int lastPage = response['last_page'];

      setState(() {
        if (page == 1) {
          digitalCards = cards;
        } else {
          digitalCards.addAll(cards);
        }
        _currentPage = page;
        _hasMoreData = page < lastPage;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching digital cards: $e");
      }
    } finally {
      if (page == 1) {
        setState(() => _isLoading = false);
      } else {
        setState(() => _isLoadingMore = false);
      }
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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          border: TableBorder.all(color: Colors.blue),
                          columns: const [
                            DataColumn(label: Text("Sr. No")),
                            DataColumn(label: Text("Date")),
                            DataColumn(label: Text("Customer \nName")),
                            DataColumn(label: Text("Shipping \nAddress")),

                            DataColumn(
                                label: Text("No of full \nDelivered Jars")),
                            DataColumn(label: Text("No of \nreturned Jars")),
                            //
                            DataColumn(label: Text("Balance")),
                            DataColumn(label: Text("Delivered by")),
                            DataColumn(label: Text("Approved by")),
                          ],
                          rows: digitalCards.isEmpty
                              ? [
                                  const DataRow(cells: [
                                    DataCell(Text("No data available")),
                                    DataCell(Text("-")),
                                    DataCell(Text("-")),
                                    DataCell(Text("-")),
                                    DataCell(Text("-")),
                                    DataCell(Text("-")),
                                    DataCell(Text("-")),
                                    DataCell(Text("-")),
                                    DataCell(Text("-")),
                                  ])
                                ]
                              : digitalCards.asMap().entries.map((entry) {
                                  int index = entry.key + 1;
                                  DigitalCardModel item = entry.value;

                                  return DataRow(cells: [
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(DateFormat("dd-MM-yyyy")
                                        .format(
                                            DateTime.parse(item.createdAt)))),
                                    DataCell(Text(item.order.customerName)),
                                    DataCell(Text(item.order.shippingAddress)),
                                    DataCell(Text(item.order.deliveredQty)),
                                    DataCell(Text(item.order.returnQty)),
                                    DataCell(Text(item.balance)),
                                    DataCell(Text(item.order.driverName)),
                                    DataCell(Text(item.acceptByName)),
                                  ]);
                                }).toList(),
                        ),
                      ),
                    ),
                  ),
                  if (_isLoadingMore)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(color: Colors.blue),
                    )
                  else if (_hasMoreData)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          fetchDigitalCard(page: _currentPage + 1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text("Load More"),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
