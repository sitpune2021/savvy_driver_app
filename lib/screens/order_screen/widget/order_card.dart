import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';

class OrderCard extends StatefulWidget {
  final OrderModel order;

  OrderCard({required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    DateTime orderDate = DateFormat("yyyy-MM-dd").parse(widget.order.createdAt);

// Get only the date part for comparison
    DateTime today = DateTime.now();
    DateTime yesterday = DateTime(today.year, today.month, today.day)
        .subtract(Duration(days: 1));
    DateTime parsedOrderDate =
        DateTime(orderDate.year, orderDate.month, orderDate.day);

// Check if order date is yesterday
    bool isHighPriority = parsedOrderDate == yesterday;

// Format date as "day-month-year"
    String date = "${orderDate.day}-${orderDate.month}-${orderDate.year}";
    print("*******date $date");
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${widget.order.orderId}",
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text("${widget.order.customerName}asdajkldjsh",
            //         maxLines: 1,
            //         overflow: TextOverflow.ellipsis,
            //         style: const TextStyle(
            //             fontSize: 16, fontWeight: FontWeight.bold)),
            //     // Text(date, style: const TextStyle(color: Colors.black)),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.order.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(date, style: const TextStyle(color: Colors.black)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue, size: 18),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(widget.order.customerAddress,
                      style: const TextStyle(color: Colors.black54)),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Quantity", style: TextStyle(color: Colors.black54)),
                Text("${widget.order.qty} Bottles",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Delivery Status",
                    style: TextStyle(color: Colors.black54)),
                Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.orange, size: 12),
                    const SizedBox(width: 5),
                    Text(widget.order.status,
                        style: const TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),

            Text(
              isHighPriority ? "HIGH PRIORITY" : "Normal",
              style: TextStyle(
                color: isHighPriority ? Colors.red : Colors.black,
                fontWeight:
                    isHighPriority ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
