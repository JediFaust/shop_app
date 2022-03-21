import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_provider/src/models/database.dart';
import 'package:shop_provider/src/screens/product_detail.dart';
import 'package:shop_provider/src/widgets/appbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  static const String routeName = '/list';

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appBar(
        titleText: 'Product List',
        child: StreamBuilder<QuerySnapshot>(
            stream: Database.readItems(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Error initializing database');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitChasingDots(
                    color: Colors.blue,
                  ),
                );
              }
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.amber,
                      child: InkWell(
                        onTap: () => Navigator.restorablePushNamed(
                          context,
                          ProductDetail.routeName,
                          arguments: snapshot.data!.docs[index].id,
                        ),
                        child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  image: NetworkImage(snapshot.data!.docs[index]
                                      .get('imageURL')),
                                  fit: BoxFit.cover,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(snapshot.data!.docs[index]
                                        .get('title')),
                                    Text(
                                        '${snapshot.data!.docs[index].get('price')} ${snapshot.data!.docs[index].get('currency')}'),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}