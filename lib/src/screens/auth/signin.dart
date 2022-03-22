import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/src/provider/google_sign_in.dart';
import 'package:shop_provider/src/screens/auth/otp.dart';
import 'package:shop_provider/src/screens/home.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  static const String routeName = '/signin';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController? _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: 150,
            height: 150,
            child: Image.asset('images/bg_top_left.png'),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text('Skip',
                          style: Theme.of(context).textTheme.headline3),
                    ),
                    const SizedBox(width: 15)
                  ],
                ),
                const SizedBox(height: 100),
                Text('Sign In', style: Theme.of(context).textTheme.headline1),
                const SizedBox(height: 50),
                Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                            labelText: 'Phone Number',
                          ),
                          maxLength: 13,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => OTPPage(
                                      phone: _phoneController?.text ??
                                          '+996707968858'))),
                          child: Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.googleLogin();
                            Navigator.pushNamedAndRemoveUntil(context,
                                HomeScreen.routeName, (route) => false);
                          },
                          icon: const Icon(
                            Icons.mail,
                          ),
                          label: Text(
                            'Sign In with Google',
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    Text(
                      'First time here?',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
