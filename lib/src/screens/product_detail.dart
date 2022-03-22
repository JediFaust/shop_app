import 'package:flutter/material.dart';
import 'package:shop_provider/src/models/database.dart';
import 'package:shop_provider/src/models/product.dart';
import 'package:shop_provider/src/screens/product_list.dart';
import 'package:shop_provider/src/widgets/appbar.dart';

class ProductDetail extends StatelessWidget {
  ProductDetail({Key? key, @required this.product}) : super(key: key);

  final Product? product;

  static const String routeName = '/detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('${product!.title}'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: NetworkImage(product!.imageURL as String)),
          Text('${product!.description}'),
          Text('${product!.price} ${product!.currency}'),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize:
                  const Size(120, 50), // Enter Media Query settings later
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              primary: Colors.red,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            onPressed: () async {
              await Database.deleteItem(productId: product!.id as String);
              Navigator.pushNamedAndRemoveUntil(
                  context, ProductList.routeName, (route) => false);
            },
            child: Text(
              'Delete Product',
              style: Theme.of(context).textTheme.button,
            ),
          )
        ],
      ),
    );
  }
}
