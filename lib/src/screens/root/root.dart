import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/stores/authentication/authentication_store.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> with WidgetsBindingObserver {
  AuthenticationStore _authenticationStore;
  ReactionDisposer _reaction;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reaction.call();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        if (_authenticationStore.state == AuthenticationState.authenticated ||
            _authenticationStore.state == AuthenticationState.active) {
          _authenticationStore.inactive();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _authenticationStore = Provider.of<AuthenticationStore>(context);

    if (_reaction == null) {
      _reaction = autorun(
          (_) => _onAuthenticationStateChange(_authenticationStore.state));
    }

    return Container(color: Colors.white);
  }

  void _onAuthenticationStateChange(AuthenticationState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.dashboard, (route) => route.isFirst);
      }

      if (state == AuthenticationState.created) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.seed, (route) => route.isFirst,
            arguments: () =>
                Navigator.of(context).pushReplacementNamed(Routes.dashboard));
      }

      if (state == AuthenticationState.restored) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.dashboard, (route) => route.isFirst);
      }

      if (state == AuthenticationState.unauthenticated) {
        Navigator.of(context).pushNamed(Routes.unlock,
            arguments: (isAuthenticatedSuccessfully, auth, _) {
          if (!isAuthenticatedSuccessfully) {
            return;
          }
          
          if (_authenticationStore != null) {
            _authenticationStore.active();
          }
          auth.close();
        });
      }
    });
  }
}
