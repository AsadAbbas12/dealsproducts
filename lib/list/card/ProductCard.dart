import 'package:flutter/material.dart';

import '../../Product.dart';
import '../../ProductDetailScreen.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {


  bool isImageZoomed = false;

  void toggleImageZoom() {
    setState(() {
      isImageZoomed = !isImageZoomed;
    });
  }

  bool _isHovering = false;
  double discount = 0.0; // Random().nextInt(41) + 10;

  get baseUrl =>
      "https://www.projects.xiico.net/asad-abbas/flutter-pms-api/public/"; // generate a random value between 10 and 50

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: widget.product),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13),
                  topRight: Radius.circular(13),
                ),
                child: Image.network(
                  baseUrl + widget.product.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Add left and right padding
                    margin: EdgeInsets.only(left: 8),
                    child: Text(
                      widget.product.discountPercentage.toString() + "% Off",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Add left and right padding
                    margin: EdgeInsets.only(right: 8),
                    child: Text(
                      widget.product.price.toString() + " AED",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  widget.product.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 3),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  widget.product.description.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.3), // Example hint-like background color: yellow (with opacity)
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(13),
                    bottomRight: Radius.circular(13),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  "Free Delivery",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
