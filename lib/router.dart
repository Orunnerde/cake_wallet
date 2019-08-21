import 'package:cake_wallet/src/wallets_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/screens/welcome/welcome.dart';
import 'package:cake_wallet/src/screens/new_wallet/new_wallet.dart';
import 'package:cake_wallet/src/screens/setup_pin_code/setup_pin_code.dart';
import 'package:cake_wallet/src/screens/restore/restore.dart';
import 'package:cake_wallet/src/screens/restore/restore_seed_keys.dart';

class Router {
  static Route<dynamic> generateRoute(
      SharedPreferences sharedPreferences, RouteSettings settings) {
    switch (settings.name) {
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => Welcome());
      case newWalletFromWelcomeRoute:
        return CupertinoPageRoute(
            builder: (_) => SetupPinCode(
                (context, _) => Navigator.pushNamed(context, newWalletRoute)));
      case newWalletRoute:
        return CupertinoPageRoute(
            builder: (_) => NewWallet(
                walletsService:
                    WalletsService(secureStorage: FlutterSecureStorage()),
                sharedPreferences: sharedPreferences));
      case setupPinRoute:
        return CupertinoPageRoute(
            builder: (_) => SetupPinCode((context, _) {}));
      case restoreRoute:
        return CupertinoPageRoute(builder: (_) => Restore());
      case restoreSeedKeysRoute:
        return CupertinoPageRoute(builder: (_) => RestoreSeedKeys());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
