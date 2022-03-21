import 'package:flutter/material.dart';
import 'package:shop_provider/src/widgets/appbar.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({Key? key, @required this.product}) : super(key: key);

  final String? product;

  static const String routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appBar(
        titleText: 'Product Detail',
        child: Center(
          child: Text('Details of Product by index: $product'),
        ),
      ),
    );
  }
}
