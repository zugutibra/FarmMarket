import 'package:flutter/material.dart';

import '../services/api_service.dart';

class BuyerScreen extends StatefulWidget {
  @override
  _BuyerScreenState createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  List products = []; // To store fetched products

  Future<void> _fetchProducts() async {
    // Call API to fetch all products
    final response = await ApiService().getAllProducts();
    if (response != null && response['success']) {
      setState(() {
        products = response['products']; // Assign the fetched products
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching products")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              title: Text(product['name']),
              subtitle: Text(product['description']),
              trailing: Text("\$${product['price']}"),
            ),
          );
        },
      ),
    );
  }
}
