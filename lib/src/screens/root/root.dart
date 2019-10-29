import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';

class Root extends StatefulWidget {
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> with WidgetsBindingObserver {
  AuthenticationStore _authenticationStore;
  bool _postFraneCallbackInited;
  bool _reactionOnAuthenticationStateChangeInited;

  @override
  void initState() {
    super.initState();
    _postFraneCallbackInited = false;
    _reactionOnAuthenticationStateChangeInited = false;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _authenticationStore.inactive();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _authenticationStore = Provider.of<AuthenticationStore>(context);

    if (!_postFraneCallbackInited) {
      _postFraneCallbackInited = true;
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _onAuthenticationStateChange(_authenticationStore.state));
    }

    if (!_reactionOnAuthenticationStateChangeInited) {
      _reactionOnAuthenticationStateChangeInited = true;
      reaction((_) => _authenticationStore.state,
          (state) => _onAuthenticationStateChange(state));
    }

    return Container(color: Colors.white);
  }

  void _onAuthenticationStateChange(AuthenticationState state) {
    if (state == AuthenticationState.uninitialized) {
      Navigator.of(context).pushNamed(Routes.splash);
    }

    if (state == AuthenticationState.denied) {
      Navigator.of(context).pushNamed(Routes.welcome);
    }

    if (state == AuthenticationState.allowed) {
      Navigator.of(context).pushNamed(Routes.login);
    }

    if (state == AuthenticationState.authenticated) {
      Navigator.of(context).pushNamed(Routes.dashboard);
    }

    if (state == AuthenticationState.unauthenticated) {
      Navigator.of(context).pushNamed(Routes.auth, arguments: [
        (auth, _) {
          if (_authenticationStore != null) {
            _authenticationStore.active();
          }
          auth.close();
        }
      ]);
    }
  }
}
