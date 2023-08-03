class ProductModel {
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

  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final title = json['title'] ?? json['product_title'];
    final imagesData = json['images'];

    List<String> imagesList = [];

    if (imagesData is List) {
      imagesList = imagesData.map((item) => item.toString()).toList();
    }

    return ProductModel(
      id: json['id'],
      title: title ?? 'No title available',
      description: json['description'] ?? 'No description available',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      brand: json['brand_id'].toString(),
      category: json['category_id'].toString(),
      thumbnail: json['thumbnail'] ?? '',
      images: imagesList,
    );
  }
}
