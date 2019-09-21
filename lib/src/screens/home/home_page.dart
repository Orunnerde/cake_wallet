import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cake_wallet/router.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/common/node_list.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/stores/balance/balance_store.dart';
import 'package:cake_wallet/src/stores/sync/sync_store.dart';
import 'package:cake_wallet/src/stores/transaction_list/transaction_list_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/stores/node_list/node_list_store.dart';
import 'package:cake_wallet/src/screens/dashboard/dashboard_page.dart';
import 'package:cake_wallet/src/screens/nodes/nodes_list_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context);
    final sharedPreferences = Provider.of<SharedPreferences>(context);
    final userService = Provider.of<UserService>(context);
    final walletService = Provider.of<WalletService>(context);
    final walletListService = Provider.of<WalletListService>(context);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        border: null,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.home),
            title: const Text('Wallet'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.search),
            title: const Text('Exchange'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.shopping_cart),
            title: const Text('Settings'),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
                onGenerateRoute: (settings) => Router.generateRoute(
                    sharedPreferences,
                    walletListService,
                    walletService,
                    userService,
                    db,
                    settings),
                builder: (context) => MultiProvider(providers: [
                      Provider(
                        builder: (context) =>
                            TransactionListStore(walletService: walletService),
                      ),
                      Provider(
                        builder: (context) =>
                            BalanceStore(walletService: walletService),
                      ),
                      Provider(
                        builder: (context) =>
                            WalletStore(walletService: walletService),
                      ),
                      Provider(
                        builder: (context) =>
                            SyncStore(walletService: walletService),
                      ),
                    ], child: DashboardPage(walletService: walletService)));
          case 1:
            return Container();
          case 2:
            return CupertinoTabView(
                onGenerateRoute: (settings) => Router.generateRoute(
                    sharedPreferences,
                    walletListService,
                    walletService,
                    userService,
                    db,
                    settings),
                builder: (context) => Provider(
                    builder: (_) => NodeListStore(nodeList: NodeList(db: db)),
                    child: NodeListPage()));
        }

        return null;
      },
    );
  }
}
