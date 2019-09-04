import 'dart:io';

import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
// import 'package:cake_wallet/src/monero_wallet.dart';
// import 'package:cake_wallet/src/monero_wallets_manager.dart';
import 'package:cake_wallet/src/screens/dashboard/sync_info.dart';
import 'package:cake_wallet/src/screens/send/send.dart';
// import 'package:cake_wallet/src/wallets_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cake_wallet/router.dart';
// import 'package:cake_wallet/src/user_service.dart';
import 'package:cake_wallet/src/bloc/authentication/authentication.dart';
import 'package:cake_wallet/src/screens/welcome/welcome.dart';
import 'package:cake_wallet/src/screens/splash/splash.dart';
import 'package:cake_wallet/src/screens/login/login.dart';
import 'package:cake_wallet/src/screens/dashboard/dashboard.dart';
import 'package:provider/provider.dart';
// import 'package:cake_wallet/src/sync_status.dart';

import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';

import 'package:cake_wallet/src/screens/transaction_details/transaction_details.dart';

void main() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  final walletService = WalletService();
  final walletListService = WalletListService(
      secureStorage: FlutterSecureStorage(), walletService: walletService);

  walletListService.changeWalletManger(walletType: WalletType.MONERO);
  final price = await fetchPriceFor(crypto: CryptoCurrency.XMR, fiat: FiatCurrency.USD);
  print('price $price');
  // HttpClient client = new HttpClient();
  // await client
  //     .getUrl(Uri.parse("http://eu-node.cakewallet.io:18081/json_rpc"))
  //     .then((HttpClientRequest request) {
  //   return request.close();
  // }).then((HttpClientResponse response) {
  //   print(response.toString());
  //   print(response.statusCode);
  // });

  // WalletInfo walletInfo = WalletInfo(wallet: MoneroWallet());

  // final syncInfo = walletInfo.syncInfo;
  // final balanceInfo = walletInfo.balanceInfo;
  // final transactionsInfo = walletInfo.transactionsInfo;

  // syncInfo.addListener(() async {
  //   if (syncInfo.status == SyncedSyncStatus) {
  //     await balanceInfo.updateBalances();
  //     await transactionsInfo.updateTransactionsList();
  //   }
  // });

  // walletInfo.addListener(() {

  // });

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
          walletListService: walletListService)));
}

class CakeWalletApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final WalletService walletService;
  final WalletListService walletListService;

  CakeWalletApp(
      {@required this.sharedPreferences,
      @required this.walletService,
      @required this.walletListService});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.white,
    ));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
        ),
        onGenerateRoute: (settings) => Router.generateRoute(
            sharedPreferences, walletListService, walletService, settings),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            // return TransactionDetails();

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
