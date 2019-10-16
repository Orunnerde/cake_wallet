import 'package:cake_wallet/src/screens/trade_history/trade_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:cake_wallet/routes.dart';

// MARK: Import domains

import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/services/address_book_service.dart';
import 'package:cake_wallet/src/domain/exchange/trade_history.dart';
import 'package:cake_wallet/src/domain/common/recipient_address_list.dart';

// MARK: Import stores

import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';
import 'package:cake_wallet/src/stores/login/login_store.dart';
import 'package:cake_wallet/src/stores/node_list/node_list_store.dart';
import 'package:cake_wallet/src/stores/auth/auth_store.dart';
import 'package:cake_wallet/src/stores/balance/balance_store.dart';
import 'package:cake_wallet/src/stores/send/send_store.dart';
import 'package:cake_wallet/src/stores/subaddress_creation/subaddress_creation_store.dart';
import 'package:cake_wallet/src/stores/subaddress_list/subaddress_list_store.dart';
import 'package:cake_wallet/src/stores/sync/sync_store.dart';
import 'package:cake_wallet/src/stores/transaction_list/transaction_list_store.dart';
import 'package:cake_wallet/src/stores/user/user_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/stores/wallet_creation/wallet_creation_store.dart';
import 'package:cake_wallet/src/stores/wallet_list/wallet_list_store.dart';
import 'package:cake_wallet/src/stores/wallet_restoration/wallet_restoration_store.dart';
import 'package:cake_wallet/src/stores/wallet_seed/wallet_seed_store.dart';
import 'package:cake_wallet/src/stores/account_list/account_list_store.dart';
import 'package:cake_wallet/src/stores/address_book/address_book_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_keys_store.dart';
import 'package:cake_wallet/src/stores/trade_history/trade_history_store.dart';
import 'package:cake_wallet/src/stores/exchange_trade/exchange_trade_store.dart';

// MARK: Import screens

import 'package:cake_wallet/src/screens/auth/auth_page.dart';
import 'package:cake_wallet/src/screens/dashboard/dashboard_page.dart';
import 'package:cake_wallet/src/screens/home/home_page.dart';
import 'package:cake_wallet/src/screens/login/login_page.dart';
import 'package:cake_wallet/src/screens/nodes/new_node_page.dart';
import 'package:cake_wallet/src/screens/nodes/nodes_list_page.dart';
import 'package:cake_wallet/src/screens/receive/receive_page.dart';
import 'package:cake_wallet/src/screens/subaddress/new_subaddress_page.dart';
import 'package:cake_wallet/src/screens/wallet_list/wallet_list_page.dart';
import 'package:cake_wallet/src/screens/welcome/welcome_page.dart';
import 'package:cake_wallet/src/screens/new_wallet/new_wallet_page.dart';
import 'package:cake_wallet/src/screens/setup_pin_code/setup_pin_code.dart';
import 'package:cake_wallet/src/screens/restore/restore_options_page.dart';
import 'package:cake_wallet/src/screens/restore/restore_wallet_options_page.dart';
import 'package:cake_wallet/src/screens/restore/restore_wallet_from_seed_page.dart';
import 'package:cake_wallet/src/screens/restore/restore_wallet_from_keys_page.dart';
import 'package:cake_wallet/src/screens/seed/seed_page.dart';
import 'package:cake_wallet/src/screens/send/send_page.dart';
import 'package:cake_wallet/src/screens/disclaimer/disclaimer_page.dart';
import 'package:cake_wallet/src/screens/seed_alert/seed_alert.dart';
import 'package:cake_wallet/src/screens/transaction_details/transaction_details_page.dart';
import 'package:cake_wallet/src/screens/accounts/account_page.dart';
import 'package:cake_wallet/src/screens/accounts/account_list_page.dart';
import 'package:cake_wallet/src/screens/address_book/address_book_page.dart';
import 'package:cake_wallet/src/screens/address_book/contact_page.dart';
import 'package:cake_wallet/src/screens/show_keys/show_keys_page.dart';
import 'package:cake_wallet/src/screens/exchange_trade/exchange_confirm_page.dart';
import 'package:cake_wallet/src/screens/trade_history/trade_history_page.dart';
import 'package:cake_wallet/src/screens/exchange_trade/exchange_funds_page.dart';
import 'package:cake_wallet/src/screens/exchange_trade/exchange_trade_page.dart';
import 'package:cake_wallet/src/screens/subaddress/subaddress_list_page.dart';

class Router {
  static Route<dynamic> generateRoute(
      SharedPreferences sharedPreferences,
      WalletListService walletListService,
      WalletService walletService,
      UserService userService,
      Database db,
      RouteSettings settings) {
    switch (settings.name) {
      case Routes.welcome:
        return MaterialPageRoute(builder: (_) => WelcomePage());

      case Routes.newWalletFromWelcome:
        return CupertinoPageRoute(
            builder: (_) => Provider(
                builder: (_) => UserStore(
                    accountService: UserService(
                        secureStorage: FlutterSecureStorage(),
                        sharedPreferences: sharedPreferences)),
                child: SetupPinCodePage(
                    onPinCodeSetup: (context, _) =>
                        Navigator.pushNamed(context, Routes.newWallet))));

      case Routes.newWallet:
        return CupertinoPageRoute(
            builder:
                (_) =>
                    ProxyProvider<AuthenticationStore, WalletCreationStore>(
                        builder: (_, authStore, __) => WalletCreationStore(
                            authStore: authStore,
                            sharedPreferences: sharedPreferences,
                            walletListService: walletListService),
                        child: NewWalletPage(
                            walletsService: walletListService,
                            walletService: walletService,
                            sharedPreferences: sharedPreferences)));

      case Routes.setupPin:
        Function(BuildContext, String) callback;

        if (settings.arguments is Function(BuildContext, String)) {
          callback = settings.arguments;
        }

        return CupertinoPageRoute(
            builder: (_) => Provider(
                builder: (_) => UserStore(
                    accountService: UserService(
                        secureStorage: FlutterSecureStorage(),
                        sharedPreferences: sharedPreferences)),
                child: SetupPinCodePage(
                    onPinCodeSetup: (context, pin) =>
                        callback == null ? null : callback(context, pin))),
            fullscreenDialog: true);

      case Routes.restoreOptions:
        return CupertinoPageRoute(builder: (_) => RestoreOptionsPage());

      case Routes.restoreWalletOptions:
        return CupertinoPageRoute(builder: (_) => RestoreWalletOptionsPage());

      case Routes.restoreWalletOptionsFromWelcome:
        return CupertinoPageRoute(
            builder: (_) => Provider(
                builder: (_) => UserStore(
                    accountService: UserService(
                        secureStorage: FlutterSecureStorage(),
                        sharedPreferences: sharedPreferences)),
                child: SetupPinCodePage(
                    onPinCodeSetup: (context, _) => Navigator.pushNamed(
                        context, Routes.restoreWalletOptions))));

      case Routes.seed:
        return MaterialPageRoute(
            builder: (_) => Provider(
                builder: (context) =>
                    WalletSeedStore(walletService: walletService),
                child: SeedPage()));

      case Routes.restoreWalletFromSeed:
        return CupertinoPageRoute(
            builder: (_) =>
                ProxyProvider<AuthenticationStore, WalletRestorationStore>(
                    builder: (_, authStore, __) => WalletRestorationStore(
                        authStore: authStore,
                        sharedPreferences: sharedPreferences,
                        walletListService: walletListService),
                    child: RestoreWalletFromSeedPage(
                        walletsService: walletListService,
                        walletService: walletService,
                        sharedPreferences: sharedPreferences)));

      case Routes.restoreWalletFromKeys:
        return CupertinoPageRoute(
            builder: (_) =>
                ProxyProvider<AuthenticationStore, WalletRestorationStore>(
                    builder: (_, authStore, __) => WalletRestorationStore(
                        authStore: authStore,
                        sharedPreferences: sharedPreferences,
                        walletListService: walletListService),
                    child: RestoreWalletFromKeysPage(
                        walletsService: walletListService,
                        walletService: walletService,
                        sharedPreferences: sharedPreferences)));

      case Routes.dashboard:
        return CupertinoPageRoute(
            builder: (_) => MultiProvider(providers: [
                  ProxyProvider<SettingsStore, TransactionListStore>(
                    builder: (_, settingsStore, __) => TransactionListStore(
                        walletService: walletService,
                        settingsStore: settingsStore),
                  ),
                  Provider(
                    builder: (context) =>
                        BalanceStore(walletService: walletService),
                  ),
                  ProxyProvider<SettingsStore, WalletStore>(
                      builder: (_, settingsStore, __) => WalletStore(
                          walletService: walletService,
                          settingsStore: settingsStore)),
                  Provider(
                    builder: (context) =>
                        SyncStore(walletService: walletService),
                  ),
                ], child: DashboardPage()));

      case Routes.send:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiProvider(providers: [
                  Provider(
                      builder: (_) =>
                          BalanceStore(walletService: walletService)),
                  ProxyProvider<SettingsStore, WalletStore>(
                      builder: (_, settingsStore, __) => WalletStore(
                          walletService: walletService,
                          settingsStore: settingsStore)),
                  ProxyProvider<SettingsStore, SendStore>(
                      builder: (_, settingsStore, __) => SendStore(
                          walletService: walletService,
                          settingsStore: settingsStore,
                          recipientAddressList: RecipientAddressList(db: db))),
                ], child: SendPage()));

      case Routes.receive:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => MultiProvider(providers: [
                  ProxyProvider<SettingsStore, WalletStore>(
                      builder: (_, settingsStore, __) => WalletStore(
                          walletService: walletService,
                          settingsStore: settingsStore)),
                  Provider(
                      builder: (_) =>
                          SubaddressListStore(walletService: walletService))
                ], child: ReceivePage()));

      case Routes.transactionDetails:
        return CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (_) => Provider(
                builder: (_) => RecipientAddressList(db: db),
                child: TransactionDetailsPage(
                    transactionInfo: settings.arguments)));

      case Routes.newSubaddress:
        return CupertinoPageRoute(
            builder: (_) => Provider(
                builder: (context) =>
                    SubadrressCreationStore(walletService: walletService),
                child: NewSubaddressPage()));

      case Routes.disclaimer:
        return CupertinoPageRoute(builder: (_) => DisclaimerPage());

      case Routes.readDisclaimer:
        return CupertinoPageRoute(
            builder: (_) => DisclaimerPage(isReadOnly: true));

      case Routes.seedAlert:
        return CupertinoPageRoute(builder: (_) => SeedAlert());

      case Routes.walletList:
        return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => Provider(
                builder: (context) => WalletListStore(
                    walletListService: walletListService,
                    walletService: walletService),
                child: WalletListPage()));

      case Routes.auth:
        void Function(AuthPage, BuildContext) onAuthenticationSuccessful;
        void Function(AuthPage, BuildContext) onAuthenticationFailed;

        if (settings.arguments is List<void Function(AuthPage, BuildContext)>) {
          final args =
              settings.arguments as List<void Function(AuthPage, BuildContext)>;

          if (args.length > 0) {
            onAuthenticationSuccessful = args[0];
          }

          if (args.length > 1) {
            onAuthenticationFailed = args[1];
          }
        }

        return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => Provider(
                  builder: (context) => AuthStore(userService: userService),
                  child: AuthPage(
                      onAuthenticationSuccessful: onAuthenticationSuccessful,
                      onAuthenticationFailed: onAuthenticationFailed),
                ));

      case Routes.nodeList:
        return CupertinoPageRoute(builder: (context) {
          return Provider(
              builder: (_) => NodeListStore(nodeList: NodeList(db: db)),
              child: NodeListPage());
        });

      case Routes.newNode:
        return CupertinoPageRoute(
            builder: (_) => Provider<NodeListStore>(
                builder: (_) => NodeListStore(nodeList: NodeList(db: db)),
                child: NewNodePage()));

      case Routes.home:
        return CupertinoPageRoute(builder: (_) => HomePage());

      case Routes.login:
        return CupertinoPageRoute(
            builder: (_) => ProxyProvider<AuthenticationStore, LoginStore>(
                builder: (context, authStore, _) => LoginStore(
                    authStore: authStore,
                    sharedPreferences: sharedPreferences,
                    userService: userService,
                    walletService: walletService,
                    walletsService: walletListService),
                child: LoginPage(
                  userService: UserService(
                      sharedPreferences: sharedPreferences,
                      secureStorage: FlutterSecureStorage()),
                  walletsService: walletListService,
                  walletService: walletService,
                  sharedPreferences: sharedPreferences,
                )));

      case Routes.accountList:
        return MaterialPageRoute(
            builder: (context) {
              return MultiProvider(providers: [
                Provider(
                    builder: (_) =>
                        AccountListStore(walletService: walletService)),
                ProxyProvider<SettingsStore, WalletStore>(
                    builder: (_, settingsStore, __) => WalletStore(
                        walletService: walletService,
                        settingsStore: settingsStore))
              ], child: AccountListPage());
            },
            fullscreenDialog: true);

      case Routes.accountCreation:
        return CupertinoPageRoute(builder: (context) {
          return Provider(
              builder: (_) => AccountListStore(walletService: walletService),
              child: AccountPage());
        });

      case Routes.addressBook:
        return MaterialPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              Provider(
                  builder: (_) =>
                      AccountListStore(walletService: walletService)),
              Provider(
                  builder: (_) => AddressBookStore(
                      addressBookService: AddressBookService(db: db)))
            ],
            child: AddressBookPage(),
          );
        });

      case Routes.pickerAddressBook:
        return MaterialPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              Provider(
                  builder: (_) =>
                      AccountListStore(walletService: walletService)),
              Provider(
                  builder: (_) => AddressBookStore(
                      addressBookService: AddressBookService(db: db)))
            ],
            child: AddressBookPage(isEditable: false),
          );
        });

      case Routes.addressBookAddContact:
        return CupertinoPageRoute(builder: (context) {
          return MultiProvider(
            providers: [
              Provider(
                builder: (_) => AccountListStore(walletService: walletService),
              ),
              Provider(
                  builder: (_) => AddressBookStore(
                      addressBookService: AddressBookService(db: db)))
            ],
            child: ContactPage(),
          );
        });

      case Routes.showKeys:
        return MaterialPageRoute(
            builder: (context) {
              return Provider(
                builder: (_) => WalletKeysStore(walletService: walletService),
                child: ShowKeysPage(),
              );
            },
            fullscreenDialog: true);

      case Routes.exchangeTrade:
        return CupertinoPageRoute(
            builder: (_) => MultiProvider(
                  providers: [
                    ProxyProvider<SettingsStore, ExchangeTradeStore>(
                      builder: (_, settingsStore, __) => ExchangeTradeStore(
                          trade: settings.arguments,
                          walletStore: WalletStore(
                              walletService: WalletService(),
                              settingsStore: settingsStore)),
                    ),
                    ProxyProvider<SettingsStore, WalletStore>(
                      builder: (_, settingsStore, __) => WalletStore(
                          walletService: WalletService(),
                          settingsStore: settingsStore),
                    ),
                    ProxyProvider<SettingsStore, SendStore>(
                        builder: (_, settingsStore, __) => SendStore(
                            recipientAddressList: RecipientAddressList(db: db),
                            walletService: walletService,
                            settingsStore: settingsStore)),
                  ],
                  child: ExchangeTradePage(),
                ));

      case Routes.exchangeConfirm:
        return MaterialPageRoute(
            builder: (_) => ExchangeConfirmPage(trade: settings.arguments));

      case Routes.tradeHistory:
        return MaterialPageRoute(builder: (context) {
          return Provider(
              builder: (_) =>
                  TradeHistoryStore(tradeHistory: TradeHistory(db: db)),
              child: TradeHistoryPage());
        });

      case Routes.tradeDetails:
        return MaterialPageRoute(builder: (context) {
          return MultiProvider(providers: [
            ProxyProvider<SettingsStore, ExchangeTradeStore>(
              builder: (_, settingsStore, __) => ExchangeTradeStore(
                  trade: settings.arguments,
                  walletStore: WalletStore(
                      walletService: WalletService(),
                      settingsStore: settingsStore)),
            )
          ], child: TradeDetailsPage());
        });

      case Routes.subaddressList:
        return MaterialPageRoute(
            builder: (_) => MultiProvider(providers: [
                  ProxyProvider<SettingsStore, WalletStore>(
                      builder: (_, settingsStore, __) => WalletStore(
                          walletService: walletService,
                          settingsStore: settingsStore)),
                  Provider(
                      builder: (_) =>
                          SubaddressListStore(walletService: walletService))
                ], child: SubaddressListPage()));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
