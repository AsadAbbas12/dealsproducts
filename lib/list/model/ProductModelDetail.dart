import 'dart:convert';

class ProductModelDetail {
  final int id;
  final String productTitle;
  final double discountPercentage;
  final double rating;
  final double price;
  final int stock;
  final String description;
  final int brandId;
  final int categoryId;
  final String thumbnail;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModelDetail({
    required this.id,
    required this.productTitle,
    required this.discountPercentage,
    required this.rating,
    required this.price,
    required this.stock,
    required this.description,
    required this.brandId,
    required this.categoryId,
    required this.thumbnail,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModelDetail.fromJson(Map<String, dynamic> json) {
    return ProductModelDetail(
      id: json['id'],
      productTitle: json['product_title'],
      discountPercentage: json['discountPercentage'].toDouble(),
      rating: json['rating'].toDouble(),
      price: json['price'].toDouble(),
      stock: json['stock'],
      description: json['description'],
      brandId: json['brand_id'],
      categoryId: json['category_id'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(jsonDecode(json['images'])),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
