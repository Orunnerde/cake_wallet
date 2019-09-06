import 'package:flutter/material.dart';
import 'package:cake_wallet/router.dart';
import 'package:cake_wallet/routes.dart';
import 'package:flutter/services.dart';

void main() => runApp(CakeWalletApp());

class CakeWalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.white,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      onGenerateRoute: Router.generateRoute,
      initialRoute: welcomeRoute,
    );
  }
}