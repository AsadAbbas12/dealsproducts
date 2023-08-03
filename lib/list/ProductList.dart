import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../ProductWidget.dart';
import 'model/ProductModel.dart';
import 'card/ProductCard.dart';

class ProductList extends StatelessWidget {
  final List<ProductModel> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    int columnCount = 2;
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 576) {
      columnCount = 3;
    }
    if (screenWidth > 768) {
      columnCount = 4;
    }
    if (screenWidth > 992) {
      columnCount = 5;
    }
    if (screenWidth > 1200) {
      columnCount = 8;
    }

    EdgeInsetsGeometry paddingValue = const EdgeInsets.all(10.0);
    if (screenWidth > 1200) {
      paddingValue = const EdgeInsets.fromLTRB(240.0, 20.0, 240.0, 40.0);
    }

    return Container(
      alignment: Alignment.center,
      child: StaggeredGridView.countBuilder(
          crossAxisCount: columnCount,
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(product: products[index]),
        staggeredTileBuilder: (int index) =>
            StaggeredTile.fit(columnCount == 2 ? 1 : 2),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        padding: paddingValue,
      ),
    );
  }
}
