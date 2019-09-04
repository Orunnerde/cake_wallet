import 'package:cake_wallet/src/bloc/user/user_bloc.dart';

import 'package:cake_wallet/src/screens/dashboard/dashboard.dart';
// import 'package:cake_wallet/src/user_service.dart';
// import 'package:cake_wallet/src/wallets_service.dart';
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
import 'package:cake_wallet/src/screens/seed/seed.dart';
import 'package:cake_wallet/src/screens/restore/restore_from_seed.dart';
import 'package:cake_wallet/src/screens/restore/restore_from_keys.dart';
import 'package:cake_wallet/src/screens/dashboard/dashboard.dart';
import 'package:provider/provider.dart';
// import 'package:cake_wallet/src/sync_status.dart';
import 'package:cake_wallet/src/screens/dashboard/sync_info.dart';
// import 'package:cake_wallet/src/monero_wallet.dart';

import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';

import 'package:cake_wallet/src/screens/send/send.dart';

import 'package:cake_wallet/src/screens/transaction_details/transaction_details.dart';

class Router {
  static Route<dynamic> generateRoute(
      SharedPreferences sharedPreferences,
      WalletListService walletListService,
      WalletService walletService,
      RouteSettings settings) {
    switch (settings.name) {
      case welcomeRoute:
        return MaterialPageRoute(builder: (_) => Welcome());

      case newWalletFromWelcomeRoute:
        return CupertinoPageRoute(
            builder: (_) => SetupPinCode(
                UserBloc(UserService(
                    secureStorage: FlutterSecureStorage(),
                    sharedPreferences: sharedPreferences)),
                (context, _) => Navigator.pushNamed(context, newWalletRoute)));

      case newWalletRoute:
        return CupertinoPageRoute(
            builder: (_) => NewWallet(
                walletsService: walletListService,
                walletService: walletService,
                sharedPreferences: sharedPreferences));

      case setupPinRoute:
        return CupertinoPageRoute(
            builder: (_) => SetupPinCode(
                UserBloc(UserService(
                    secureStorage: FlutterSecureStorage(),
                    sharedPreferences: sharedPreferences)),
                (context, _) {}));

      case restoreRoute:
        return CupertinoPageRoute(builder: (_) => Restore());

      case restoreSeedKeysRoute:
        return CupertinoPageRoute(builder: (_) => RestoreSeedKeys());

      case restoreFromSeedKeysFromWelcomeRoute:
        return CupertinoPageRoute(
            builder: (_) => SetupPinCode(
                UserBloc(UserService(
                    secureStorage: FlutterSecureStorage(),
                    sharedPreferences: sharedPreferences)),
                (context, _) =>
                    Navigator.pushNamed(context, restoreSeedKeysRoute)));

      case seedRoute:
        return CupertinoPageRoute(builder: (_) => Seed());

      case restoreFromSeedRoute:
        return CupertinoPageRoute(
            builder: (_) => RestoreFromSeed(
                walletsService: walletListService,
                walletService: walletService,
                sharedPreferences: sharedPreferences));

      case restoreFromKeysRoute:
        return CupertinoPageRoute(
            builder: (_) => RestoreFromKeys(
                walletsService: walletListService,
                walletService: walletService,
                sharedPreferences: sharedPreferences));

      case dashboardRoute:
        return CupertinoPageRoute(
            builder: (_) => MultiProvider(providers: [
                  ChangeNotifierProvider(
                    builder: (context) =>
                        TransactionsInfo(walletService: walletService),
                  ),
                  ChangeNotifierProvider(
                    builder: (context) =>
                        BalanceInfo(walletService: walletService),
                  ),
                  ChangeNotifierProvider(
                    builder: (context) =>
                        WalletInfo(walletService: walletService),
                  ),
                  ChangeNotifierProvider(
                    builder: (context) =>
                        SyncInfo(walletService: walletService),
                  ),
                ], child: Dashboard(walletService: walletService)));

      case sendRoute:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(providers: [
                  ChangeNotifierProvider(
                    builder: (context) =>
                        BalanceInfo(walletService: walletService),
                  ),
                  ChangeNotifierProvider(
                    builder: (context) =>
                        WalletInfo(walletService: walletService),
                  ),
                  ChangeNotifierProvider(
                      builder: (context) =>
                          SendInfo(walletService: walletService)),
                ], child: Send()));

      case transactionDetailsRoute:
        return MaterialPageRoute(
            builder: (_) => TransactionDetails(transactionInfo: settings.arguments));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
