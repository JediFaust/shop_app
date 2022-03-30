import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_provider/src/screens/profile.dart';
import 'package:shop_provider/src/screens/product_create.dart';
import 'package:shop_provider/src/screens/product_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uid;
  int _index = 0;

  List<Widget> screens = [
    const ProductList(),
    const AccountPage(),
  ];

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser?.uid ?? 'invalid User ID';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () =>
            Navigator.restorablePushNamed(context, ProductCreate.routeName),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber,
          currentIndex: _index,
          onTap: (int index) => setState(() => _index = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account_rounded),
              label: 'Account',
            ),
          ]),
    );
  }
}
