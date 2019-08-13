import 'package:flutter/material.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/screens/welcome/welcome.dart';
import 'package:cake_wallet/src/screens/restore/restore.dart';
import 'package:cake_wallet/src/screens/restore/restore_seed_keys.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => Welcome());
      case restoreRoute:
        return MaterialPageRoute(builder: (_) => Restore());
      case restoreSeedKeysRoute:
        return MaterialPageRoute(builder: (_) => RestoreSeedKeys());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}