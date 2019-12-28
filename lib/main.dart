import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:cw_monero/wallet.dart' as moneroWallet;
import 'package:cake_wallet/router.dart';
import 'theme_changer.dart';
import 'themes.dart';
import 'package:cake_wallet/src/domain/common/contact.dart';
import 'package:cake_wallet/src/domain/common/node.dart';
import 'package:cake_wallet/src/domain/common/wallet_info.dart';
import 'package:cake_wallet/src/domain/exchange/trade.dart';
import 'package:cake_wallet/src/domain/monero/transaction_description.dart';
import 'package:cake_wallet/src/reactions/set_reactions.dart';
import 'package:cake_wallet/src/stores/login/login_store.dart';
import 'package:cake_wallet/src/stores/balance/balance_store.dart';
import 'package:cake_wallet/src/stores/sync/sync_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/screens/root/root.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/stores/price/price_store.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/common/balance_display_mode.dart';
import 'package:cake_wallet/src/domain/common/default_settings_migration.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/domain/common/transaction_priority.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:cake_wallet/src/domain/common/language.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);
  Hive.registerAdapter(ContactAdapter(), 0);
  Hive.registerAdapter(NodeAdapter(), 1);
  Hive.registerAdapter(TransactionDescriptionAdapter(), 2);
  Hive.registerAdapter(TradeAdapter(), 3);
  Hive.registerAdapter(WalletInfoAdapter(), 4);
  Hive.registerAdapter(WalletTypeAdapter(), 5);

  var contacts = await Hive.openBox<Contact>(Contact.boxName);
  var nodes = await Hive.openBox<Node>(Node.boxName);
  var transactionDescriptions = await Hive.openBox<TransactionDescription>(
      TransactionDescription.boxName);
  var trades = await Hive.openBox<Trade>(Trade.boxName);
  var walletInfoSource = await Hive.openBox<WalletInfo>(WalletInfo.boxName);

  final sharedPreferences = await SharedPreferences.getInstance();
  final walletService = WalletService();
  final walletListService = WalletListService(
      secureStorage: FlutterSecureStorage(),
      walletInfoSource: walletInfoSource,
      walletService: walletService,
      sharedPreferences: sharedPreferences);
  final userService = UserService(
      sharedPreferences: sharedPreferences,
      secureStorage: FlutterSecureStorage());
  final authenticationStore = AuthenticationStore(userService: userService);

  await initialSetup(
      sharedPreferences: sharedPreferences,
      walletListService: walletListService,
      nodes: nodes,
      authStore: authenticationStore);

  final settingsStore = await SettingsStoreBase.load(
      nodes: nodes,
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
    Provider(builder: (_) => settingsStore),
    Provider(builder: (_) => priceStore),
    Provider(builder: (_) => walletStore),
    Provider(builder: (_) => syncStore),
    Provider(builder: (_) => balanceStore),
    Provider(builder: (_) => authenticationStore),
    Provider(builder: (_) => contacts),
    Provider(builder: (_) => nodes),
    Provider(builder: (_) => transactionDescriptions),
    Provider(builder: (_) => trades)
  ], child: CakeWalletApp()));
}

initialSetup(
    {WalletListService walletListService,
    SharedPreferences sharedPreferences,
    Box<Node> nodes,
    AuthenticationStore authStore,
    int initialMigrationVersion = 1,
    WalletType initialWalletType = WalletType.monero}) async {
  await walletListService.changeWalletManger(walletType: initialWalletType);
  await defaultSettingsMigration(
      version: initialMigrationVersion,
      sharedPreferences: sharedPreferences,
      nodes: nodes);
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
    final settingsStore = Provider.of<SettingsStore>(context);
    final priceStore = Provider.of<PriceStore>(context);
    final walletStore = Provider.of<WalletStore>(context);
    final syncStore = Provider.of<SyncStore>(context);
    final balanceStore = Provider.of<BalanceStore>(context);
    final theme = Provider.of<ThemeChanger>(context);
    final statusBarColor =
        settingsStore.isDarkTheme ? Colors.black : Colors.white;
    final currentLanguage = Provider.of<Language>(context);
    final contacts = Provider.of<Box<Contact>>(context);
    final nodes = Provider.of<Box<Node>>(context);
    final trades = Provider.of<Box<Trade>>(context);
    final transactionDescriptions = Provider.of<Box<TransactionDescription>>(context);

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
            settings: settings,
            priceStore: priceStore,
            walletStore: walletStore,
            syncStore: syncStore,
            balanceStore: balanceStore,
            settingsStore: settingsStore,
            contacts: contacts,
            nodes: nodes,
            trades: trades,
            transactionDescriptions: transactionDescriptions),
        home: Root());
  }
}
