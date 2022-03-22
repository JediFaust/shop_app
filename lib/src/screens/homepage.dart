import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shop_provider/src/screens/auth/signin.dart';
import 'package:shop_provider/src/screens/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinKitChasingDots(color: Colors.yellow));
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else if (snapshot.hasError) {
          return Center(
              child: Row(
            children: [
              const Text("Something went wrong"),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, SignInPage.routeName, (route) => false),
                child: const Text("Sign In"),
              )
            ],
          ));
        } else {
          return SignInPage();
        }
      },
    );
  }
}
