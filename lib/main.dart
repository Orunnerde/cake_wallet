import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/common/wallet.dart';
import 'package:cake_wallet/src/domain/common/wallet_description.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/screens/dashboard/sync_info.dart';
import 'package:cake_wallet/src/screens/wallets/wallets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cake_wallet/router.dart';

import 'package:cake_wallet/src/bloc/authentication/authentication.dart';
import 'package:cake_wallet/src/screens/welcome/welcome.dart';
import 'package:cake_wallet/src/screens/splash/splash.dart';
import 'package:cake_wallet/src/screens/login/login.dart';
import 'package:cake_wallet/src/screens/dashboard/dashboard.dart';
import 'package:provider/provider.dart';

import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';

import 'dart:async';

void main() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  final dbHelper = await DbHelper.getInstance();
  final db = await dbHelper.getDb();

  final walletService = WalletService();
  final walletListService = WalletListService(
      secureStorage: FlutterSecureStorage(),
      db: db,
      walletService: walletService,
      sharedPreferences: sharedPreferences);

  final userService = UserService(
      sharedPreferences: sharedPreferences,
      secureStorage: FlutterSecureStorage());

  await walletListService.changeWalletManger(walletType: WalletType.MONERO);

  var _lastIsConnected = false;

//  Timer.periodic(Duration(seconds: 10), (_) async {
//    if (walletService.currentWallet == null) {
//      return;
//    }
//
//    final isConnected = await walletService.isConnected();
//
//    print('isConnected $isConnected');
//
//    if (!isConnected &&
//        !(walletService.syncStatusValue is ConnectingSyncStatus ||
//            walletService.syncStatusValue is StartingSyncStatus)) {
//      print('Start to reconnect');
//      try {
//        await walletService.connectToNode(
//            uri: 'node.moneroworld.com:18089', login: '', password: '');
//      } catch (e) {
//        print('Error while reconnection');
//        print(e);
//      }
//    }
//  });

  runApp(BlocProvider<AuthenticationBloc>(
      builder: (context) {
        return AuthenticationBloc(
            userService: UserService(
                secureStorage: FlutterSecureStorage(),
                sharedPreferences: sharedPreferences))
          ..dispatch(AppStarted());
      },
      child: CakeWalletApp(
          sharedPreferences: sharedPreferences,
          walletService: walletService,
          walletListService: walletListService,
          userService: userService)));
}

class CakeWalletApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final WalletService walletService;
  final WalletListService walletListService;
  final UserService userService;

  CakeWalletApp(
      {@required this.sharedPreferences,
      @required this.walletService,
      @required this.walletListService,
      @required this.userService});

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
        onGenerateRoute: (settings) => Router.generateRoute(
            sharedPreferences, walletListService, walletService, userService, settings),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUninitialized) {
              return Splash();
            }

            if (state is AuthenticationAuthenticated) {
              return MultiProvider(providers: [
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
                  builder: (context) => SyncInfo(walletService: walletService),
                ),
              ], child: Dashboard(walletService: walletService));
            }

            if (state is AuthenticationDenied) {
              return Welcome();
            }

            if (state is AuthenticationAllowed) {
              return ChangeNotifierProvider<WalletInfo>(
                  builder: (context) =>
                      WalletInfo(walletService: walletService),
                  child: LoginScreen(
                    userService: UserService(
                        sharedPreferences: sharedPreferences,
                        secureStorage: FlutterSecureStorage()),
                    walletsService: walletListService,
                    walletService: walletService,
                    sharedPreferences: sharedPreferences,
                  ));
            }

            return Container();
          },
        ));
  }
}
