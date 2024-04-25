import 'package:flutter/material.dart';
import 'models/Invoice.dart';
import 'models/Order.dart';

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<Invoice> invoices = []; // Assume you have a list of invoices
  Map<int, List<Order>> orderMap = {}; // Map to store orders by invoice ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return ExpansionTile(
            title: Text('Invoice ${invoice.id}'),
            subtitle: Text('Total: \$${invoice.total.toStringAsFixed(2)}'),
            children: [
              FutureBuilder<List<Order>>(
                future: _getOrdersByInvoiceId(invoice.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final orders = snapshot.data ?? [];
                    return Column(
                      children: orders
                          .map((order) => ListTile(
                                title: Text('Order ${order.id}'),
                                subtitle: Text('Song ID: ${order.songId}'),
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<Order>> _getOrdersByInvoiceId(int invoiceId) async {
    // Assume you have a function to fetch orders by invoice ID
    if (orderMap.containsKey(invoiceId)) {
      // If orders for this invoice ID are already fetched, return them
      return orderMap[invoiceId]!;
    } else {
      // Otherwise, fetch orders from API or database
      List<Order> orders = []; // Fetch orders from your data source
      orderMap[invoiceId] = orders; // Store orders in the map
      return orders;
    }
  }
}
