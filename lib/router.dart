import 'package:flutter/material.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/screens/welcome/welcome.dart';
import 'package:cake_wallet/src/screens/new_wallet/new_wallet.dart';
import 'package:cake_wallet/src/screens/setup_pin_code/setup_pin_code.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => Welcome());
      case newWalletRoute:
        return MaterialPageRoute(builder: (_) => NewWallet());
      case setupPinRoute:
        return MaterialPageRoute(builder: (_) => SetupPinCode());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}