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

  final priceStore = PriceStore();

  reaction((_) => settingsStore.node, (node) async {
    final startDate = DateTime.now();
    await walletService.connectToNode(node: node);
    print(
        'Connection time took ${DateTime.now().millisecondsSinceEpoch - startDate.millisecondsSinceEpoch}');
  });

  walletService.onWalletChange.listen((wallet) async {
    startUpdatingPrice(settingsStore: settingsStore, priceStore: priceStore);

    await wallet.connectToNode(node: settingsStore.node);
    await wallet.startSync();
  });

  final authStore = AuthenticationStore(userService: userService);
  await authStore.started();

  runApp(Provider(
      builder: (_) => authStore,
      child: CakeWalletApp(
          sharedPreferences: sharedPreferences,
          walletService: walletService,
          walletListService: walletListService,
          userService: userService,
          db: db,
          settingsStore: settingsStore,
          priceStore: priceStore)));
}

class CakeWalletApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final WalletService walletService;
  final WalletListService walletListService;
  final UserService userService;
  final Database db;
  final SettingsStore settingsStore;
  final PriceStore priceStore;

  CakeWalletApp(
      {@required this.sharedPreferences,
      @required this.walletService,
      @required this.walletListService,
      @required this.userService,
      @required this.db,
      @required this.settingsStore,
      @required this.priceStore});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
        builder: (_) => ThemeChanger(
            settingsStore.isDarkTheme ? Themes.darkTheme : Themes.lightTheme),
        child: ChangeNotifierProvider<Language>(
          builder: (_) => Language(settingsStore.languageCode),
          child: MaterialAppWithTheme(
              sharedPreferences: sharedPreferences,
              walletService: walletService,
              walletListService: walletListService,
              userService: userService,
              db: db,
              settingsStore: settingsStore,
              priceStore: priceStore)));
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final WalletService walletService;
  final WalletListService walletListService;
  final UserService userService;
  final Database db;
  final SettingsStore settingsStore;
  final PriceStore priceStore;

  MaterialAppWithTheme(
      {@required this.sharedPreferences,
      @required this.walletService,
      @required this.walletListService,
      @required this.userService,
      @required this.db,
      @required this.settingsStore,
      @required this.priceStore});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    final currentLanguage = Provider.of<Language>(context);
    Color _statusBarColor =
        settingsStore.isDarkTheme ? Colors.black : Colors.white;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: _statusBarColor));

    return MultiProvider(
      providers: [
        Provider<SettingsStore>(builder: (_) => settingsStore),
        Provider<PriceStore>(builder: (_) => priceStore)
      ],
      child: MaterialApp(
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
          onGenerateRoute: (settings) => Router.generateRoute(sharedPreferences,
              walletListService, walletService, userService, db, settings,priceStore),
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
