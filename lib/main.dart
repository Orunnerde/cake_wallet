import 'dart:async';
import 'package:cake_wallet/src/reactions/set_reactions.dart';
import 'package:cake_wallet/src/stores/auth/auth_store.dart';
import 'package:cake_wallet/src/stores/login/login_store.dart';
import 'package:cw_monero/wallet.dart' as moneroWallet;
import 'package:cake_wallet/src/domain/common/sync_status.dart';
import 'package:cake_wallet/src/stores/balance/balance_store.dart';
import 'package:cake_wallet/src/stores/sync/sync_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cake_wallet/router.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cake_wallet/src/start_updating_price.dart';
import 'package:cake_wallet/src/screens/root/root.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/stores/price/price_store.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/common/core_db.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/default_settings_migration.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/src/domain/common/transaction_priority.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'theme_changer.dart';
import 'themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/src/domain/common/language.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final nodeList = NodeList(db: db);
  final authenticationStore = AuthenticationStore(userService: userService);

  await initialSetup(
      sharedPreferences: sharedPreferences,
      walletListService: walletListService,
      nodeList: nodeList,
      authStore: authenticationStore);

  final settingsStore = await SettingsStoreBase.load(
      nodeList: nodeList,
      sharedPreferences: sharedPreferences,
      initialFiatCurrency: FiatCurrency.usd,
      initialTransactionPriority: TransactionPriority.slow,
      initialBalanceDisplayMode: BalanceDisplayMode.availableBalance);
  final priceStore = PriceStore();
  final walletStore =
      WalletStore(walletService: walletService, settingsStore: settingsStore);
  final syncStore = SyncStore(walletService: walletService);
  final balanceStore = BalanceStore(
      walletService: walletService,
      settingsStore: settingsStore,
      priceStore: priceStore);
  final loginStore = LoginStore(
      sharedPreferences: sharedPreferences, walletsService: walletListService);

  setReactions(
      settingsStore: settingsStore,
      priceStore: priceStore,
      syncStore: syncStore,
      walletStore: walletStore,
      walletService: walletService,
      authenticationStore: authenticationStore,
      loginStore: loginStore);

  runApp(MultiProvider(providers: [
    Provider(builder: (_) => sharedPreferences),
    Provider(builder: (_) => walletService),
    Provider(builder: (_) => walletListService),
    Provider(builder: (_) => userService),
    Provider(builder: (_) => db),
    Provider(builder: (_) => settingsStore),
    Provider(builder: (_) => priceStore),
    Provider(builder: (_) => walletStore),
    Provider(builder: (_) => syncStore),
    Provider(builder: (_) => balanceStore),
    Provider(builder: (_) => authenticationStore)
  ], child: CakeWalletApp()));
}

initialSetup(
    {WalletListService walletListService,
    SharedPreferences sharedPreferences,
    NodeList nodeList,
    AuthenticationStore authStore,
    int initialMigrationVersion = 1,
    WalletType initialWalletType = WalletType.monero}) async {
  await walletListService.changeWalletManger(walletType: initialWalletType);
  await defaultSettingsMigration(
      version: initialMigrationVersion,
      sharedPreferences: sharedPreferences,
      nodeList: nodeList);
  await authStore.started();
  moneroWallet.onStartup();
}

class CakeWalletApp extends StatelessWidget {
  CakeWalletApp() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    final settingsStore = Provider.of<SettingsStore>(context);

    return ChangeNotifierProvider<ThemeChanger>(
        builder: (_) => ThemeChanger(
            settingsStore.isDarkTheme ? Themes.darkTheme : Themes.lightTheme),
        child: ChangeNotifierProvider<Language>(
            builder: (_) => Language(settingsStore.languageCode),
            child: MaterialAppWithTheme()));
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sharedPreferences = Provider.of<SharedPreferences>(context);
    final walletService = Provider.of<WalletService>(context);
    final walletListService = Provider.of<WalletListService>(context);
    final userService = Provider.of<UserService>(context);
    final db = Provider.of<Database>(context);
    final settingsStore = Provider.of<SettingsStore>(context);
    final priceStore = Provider.of<PriceStore>(context);
    final walletStore = Provider.of<WalletStore>(context);
    final syncStore = Provider.of<SyncStore>(context);
    final balanceStore = Provider.of<BalanceStore>(context);
    final theme = Provider.of<ThemeChanger>(context);
    final statusBarColor =
        settingsStore.isDarkTheme ? Colors.black : Colors.white;
    final currentLanguage = Provider.of<Language>(context);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: statusBarColor));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.getTheme(),
        localizationsDelegates: [
          S.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: Locale(currentLanguage.getCurrentLanguage()),
        onGenerateRoute: (settings) => Router.generateRoute(
            sharedPreferences: sharedPreferences,
            walletListService: walletListService,
            walletService: walletService,
            userService: userService,
            db: db,
            settings: settings,
            priceStore: priceStore,
            walletStore: walletStore,
            syncStore: syncStore,
            balanceStore: balanceStore,
            settingsStore: settingsStore),
        home: Root());
  }
}
