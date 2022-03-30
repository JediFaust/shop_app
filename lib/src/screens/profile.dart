import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? avatar;

  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser?.uid ?? 'invalid User ID';
    name = FirebaseAuth.instance.currentUser?.displayName ?? 'invalid Name';
    email = FirebaseAuth.instance.currentUser?.email ?? 'invalid Email';
    phone = FirebaseAuth.instance.currentUser?.phoneNumber ?? 'invalid Phone';
    avatar = FirebaseAuth.instance.currentUser?.photoURL ?? 'invalid Avatar';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber[100],
            radius: 75,
            child: (avatar != null) && (avatar != "invalid Avatar")
                ? Image(image: NetworkImage(avatar as String))
                : const FlutterLogo(size: 75),
          ),
          const SizedBox(height: 20),
          Text(
            email ?? "Username",
            style: TextStyle(color: Colors.black),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize:
                  const Size(120, 50), // Enter Media Query settings later
              padding: const EdgeInsets.symmetric(vertical: 12),
              primary: Colors.red,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/signin', (route) => false);
            },
            child: Text(
              'Sign Out',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ],
      ),
    );
  }
}
