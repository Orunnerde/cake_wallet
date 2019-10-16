import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cake_wallet/router.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cake_wallet/src/screens/root/root.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/common/core_db.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/default_settings_migration.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/src/domain/common/transaction_priority.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'theme_changer.dart';
import 'themes.dart';

void main() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  final dbHelper = await CoreDB.getInstance();
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

  await walletListService.changeWalletManger(walletType: WalletType.monero);

  final nodeList = NodeList(db: db);

  await defaultSettingsMigration(
      version: 1, sharedPreferences: sharedPreferences, nodeList: nodeList);

  final settingsStore = await SettingsStoreBase.load(
      nodeList: nodeList,
      sharedPreferences: sharedPreferences,
      initialFiatCurrency: FiatCurrency.usd,
      initialTransactionPriority: TransactionPriority.slow,
      initialBalanceDisplayMode: BalanceDisplayMode.availableBalance);

  reaction(
      (_) => settingsStore.node,
      (node) async => await walletService.connectToNode(
          uri: node.uri, login: node.login, password: node.password));

  Timer.periodic(Duration(seconds: 10), (_) async {
    if (walletService.currentWallet == null) {
      return;
    }

    final isConnected = await walletService.isConnected();

    print('isConnected $isConnected');

    if (!isConnected &&
        !(walletService.syncStatusValue is ConnectingSyncStatus ||
            walletService.syncStatusValue is StartingSyncStatus)) {
      print('Start to reconnect');
      try {
        await walletService.connectToNode(
            uri: 'node.moneroworld.com:18089', login: '', password: '');
      } catch (e) {
        print('Error while reconnection');
        print(e);
      }
    }
  });

  final authStore = AuthenticationStore(userService: userService);
  await authStore.started();

  reaction((_) => authStore.state, (state) async {
    if (state == AuthenticationState.authenticated) {
      print('Connection after wallet change');
      final node = settingsStore.node;
      await walletService.connectToNode(
          uri: node.uri, login: node.login, password: node.password);
    }
  });

  runApp(Provider(
      builder: (_) => authStore,
      child: CakeWalletApp(
          sharedPreferences: sharedPreferences,
          walletService: walletService,
          walletListService: walletListService,
          userService: userService,
          db: db,
          settingsStore: settingsStore)));
}

class CakeWalletApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final WalletService walletService;
  final WalletListService walletListService;
  final UserService userService;
  final Database db;
  final SettingsStore settingsStore;

  CakeWalletApp(
      {@required this.sharedPreferences,
        @required this.walletService,
        @required this.walletListService,
        @required this.userService,
        @required this.db,
        @required this.settingsStore});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger(Themes.lightTheme),
      child: MaterialAppWithTheme(
          sharedPreferences: sharedPreferences,
          walletService: walletService,
          walletListService: walletListService,
          userService: userService,
          db: db,
          settingsStore: settingsStore),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final WalletService walletService;
  final WalletListService walletListService;
  final UserService userService;
  final Database db;
  final SettingsStore settingsStore;

  MaterialAppWithTheme(
      {@required this.sharedPreferences,
        @required this.walletService,
        @required this.walletListService,
        @required this.userService,
        @required this.db,
        @required this.settingsStore});

  @override
  Widget build(BuildContext context) {

    final theme = Provider.of<ThemeChanger>(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.white,
    ));

    return MultiProvider(
      providers: [Provider<SettingsStore>(builder: (_) => settingsStore)],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.getTheme(),
          onGenerateRoute: (settings) => Router.generateRoute(sharedPreferences,
              walletListService, walletService, userService, db, settings),
          home: MultiProvider(providers: [
            Provider(builder: (_) => sharedPreferences),
            Provider(builder: (_) => walletService),
            Provider(builder: (_) => walletListService),
            Provider(builder: (_) => userService),
            Provider(builder: (_) => settingsStore),
            Provider(builder: (_) => db),
          ], child: Root())),
    );
  }

}