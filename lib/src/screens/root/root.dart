import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';
import 'package:cake_wallet/src/stores/login/login_store.dart';
import 'package:cake_wallet/src/screens/welcome/welcome_page.dart';
import 'package:cake_wallet/src/screens/splash/splash_page.dart';
import 'package:cake_wallet/src/screens/login/login_page.dart';
import 'package:cake_wallet/src/screens/home/home_page.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authenticationStore = Provider.of<AuthenticationStore>(context);
    final sharedPreferences = Provider.of<SharedPreferences>(context);
    final userService = Provider.of<UserService>(context);
    final walletService = Provider.of<WalletService>(context);
    final walletListService = Provider.of<WalletListService>(context);

    return Observer(builder: (context) {
      if (authenticationStore.state == AuthenticationState.uninitialized) {
        return SplashPage();
      }

      if (authenticationStore.state == AuthenticationState.denied) {
        return WelcomePage();
      }

      if (authenticationStore.state == AuthenticationState.allowed) {
        return ProxyProvider<AuthenticationStore, LoginStore>(
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
            ));
      }

      if (authenticationStore.state == AuthenticationState.authenticated) {
        return HomePage();
      }

      return Container(color: Colors.white);
    });
  }
}
