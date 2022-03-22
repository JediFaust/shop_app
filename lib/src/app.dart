import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_provider/src/models/product.dart';
import 'package:shop_provider/src/provider/google_sign_in.dart';
import 'package:shop_provider/src/screens/auth/otp.dart';
import 'package:shop_provider/src/screens/auth/signin.dart';
import 'package:shop_provider/src/screens/home.dart';
import 'package:shop_provider/src/screens/product_create.dart';
import 'package:shop_provider/src/screens/product_detail.dart';
import 'package:shop_provider/src/screens/product_list.dart';
import 'package:shop_provider/src/services/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        restorationScopeId: 'app',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,
        theme: myTheme(),
        darkTheme: myTheme(),
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) {
              switch (routeSettings.name) {
                case ProductDetail.routeName:
                  return ProductDetail(
                      product: routeSettings.arguments as Product);
                case ProductCreate.routeName:
                  return ProductCreate();
                case HomeScreen.routeName:
                  return const HomeScreen();
                case SignInPage.routeName:
                  return SignInPage();
                case OTPPage.routeName:
                  return OTPPage(
                    phone: routeSettings.arguments as String,
                  );
                case ProductList.routeName:
                default:
                  return const ProductList();
              }
            },
          );
        },
        home: SignInPage(),
      ),
    );
  }
}
