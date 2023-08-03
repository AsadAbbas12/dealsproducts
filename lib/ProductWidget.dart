import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'list/ProductList.dart';
import 'list/model/ProductModel.dart';



class ProductService {
  static const String apiUrl = 'https://uaedeals4u.ae/admin/api/public/api/products';

  static Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<ProductModel> products = parseProducts(response.body);

      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}

List<ProductModel> parseProducts(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString)['products'];
  return jsonList.map((json) => ProductModel.fromJson(json)).toList();
}


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deals 4U UAE'),
      ),
      body: Center(
        child: FutureBuilder<List<ProductModel>>(
          future: _futureProducts,
          builder:
              (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
            if (snapshot.hasData) {
              return ProductList(products: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[700]!, Colors.blue[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.date_range, color: Colors.white),

              Text(
                DateTime.now().toString(),
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),

              const Text(
                '© 2023 Deals 4U UAE. All rights reserved.',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),

              const Icon(Icons.lock, size: 10, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  int generateDiscount() {
    Random random = Random();
    int percent = random.nextInt(2) == 0 ? 20 : 30;
    return percent;
  }
}
