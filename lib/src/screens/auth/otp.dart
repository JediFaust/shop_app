import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_provider/src/services/pinput_theme.dart';
import 'package:pinput/pinput.dart';

class OTPPage extends StatefulWidget {
  OTPPage({Key? key, @required this.phone}) : super(key: key);

  static const String routeName = '/otp';

  final String? phone;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String? _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  @override
  void initState() {
    _verifyPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.topRight,
                width: 150,
                height: 150,
                child: Image.asset('images/bg_top_right.png'),
              ),
            ],
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 100),
                Text('Verification Code',
                    style: Theme.of(context).textTheme.headline1),
                SizedBox(
                  width: 300,
                  child: Text('Enter the code you recieved',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1),
                ),
                Text(widget.phone as String,
                    style: Theme.of(context).textTheme.bodyText2),
                //const SizedBox(height: 50),
                Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Pinput(
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          focusNode: _pinPutFocusNode,
                          controller: _pinPutController,
                          pinAnimationType: PinAnimationType.fade,
                          validator: (s) {
                            return s == s!.toUpperCase()
                                ? null
                                : 'Pin is incorrect';
                          },
                          pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (pin) async {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId:
                                              _verificationCode as String,
                                          smsCode: pin))
                                  .then((value) async {
                                if (value.user != null) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/home', (route) => false);
                                }
                              });
                            } catch (e) {
                              FocusScope.of(context).unfocus();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('invalid OTP')));
                            }
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 25),
                      //   child: ElevatedButton(
                      //     onPressed: () =>
                      //         Navigator.pushNamed(context, '/auth'),
                      //     child: Text('Войти',
                      //         style: Theme.of(context).textTheme.button),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    Text(
                      'Did\'t recieve code?',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/home');
                      },
                      child: Text('Send again',
                          style: Theme.of(context).textTheme.headline2),
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

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone as String,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            print('user logged in');
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationID, int? resendToken) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }
}
