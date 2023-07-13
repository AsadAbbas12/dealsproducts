import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'list/ProductList.dart';

class Product {
  final int id;
  final String title;
  final String? description;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      discountPercentage: json['discountPercentage'].toDouble(),
      rating: json['rating'].toDouble(),
      stock: json['stock'],
      brand: json['brand'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images']),
    );
  }
}

class ProductService {
  static const String apiUrl = 'https://projects.xiico.net/asad-abbas/flutter-pms-api/public/api/products';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<Product> products = parseProducts(response.body);

      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}

List<Product> parseProducts(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString)['products'];
  return jsonList.map((json) => Product.fromJson(json)).toList();
}


class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deals 4U UAE'),
      ),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: _futureProducts,
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.hasData) {
              return ProductList(products: snapshot.data!!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return CircularProgressIndicator();
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
              Icon(Icons.date_range, color: Colors.white),

              Text(
                DateTime.now().toString(),
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),

              Text(
                '© 2023 Deals 4U UAE. All rights reserved.',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),

              Icon(Icons.lock, size: 10, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  int generateDiscount() {
    Random random = new Random();
    int percent = random.nextInt(2) == 0 ? 20 : 30;
    return percent;
  }
}
