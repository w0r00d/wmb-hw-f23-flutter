import 'package:flutter/material.dart';
import 'models/Invoice.dart';
import 'models/Order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String?> getAdminStat() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'is_admin');
}
class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<Invoice> invoices = []; // Assume you have a list of invoices
  Map<int, List<Order>> orderMap = {}; // Map to store orders by invoice ID
  List <dynamic> _invoices = [];

 @override
  void initState() {
   fetching();
    super.initState();
  }
Future <void> fetching() async{
  await _fetchData();
}
Future <void> _fetchData() async{
 final response = await http.get(Uri.parse(
        'https://woroodmadwar.com/mws_wmb_f23_hw/public/api/invoice'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _invoices = jsonData['invoices'];
      //   invoices = _invoices.map((json) => Invoice.fromJson(json)).toList();
      });

    print('--------------------------');
    print(_invoices);
    } else {
      throw Exception('Failed to load invoices');
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
      ),
      body: _invoices.isNotEmpty ? ListView.builder(
        itemCount: _invoices.length,
        itemBuilder: (context, index) {
          final invoice = _invoices[index];
          return ExpansionTile(
            title: Text('Invoice ${invoice['id']}'),
            subtitle: Text('Total:  ${invoice['Total']} \n Date: ${invoice['Date']}'),
           
          );
        },
      ) : Text('no data'),
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
