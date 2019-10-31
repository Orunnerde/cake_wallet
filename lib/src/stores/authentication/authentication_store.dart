import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';
import 'package:cake_wallet/src/domain/services/wallet_list_service.dart';

part 'authentication_store.g.dart';

class AuthenticationStore = AuthenticationStoreBase with _$AuthenticationStore;

enum AuthenticationState {
  uninitialized,
  allowed,
  denied,
  authenticated,
  unauthenticated,
  active,
  loading
}

abstract class AuthenticationStoreBase with Store {
  final UserService userService;

  @observable
  AuthenticationState state;

  @observable
  String errorMessage;

  AuthenticationStoreBase({@required this.userService}) {
    state = AuthenticationState.uninitialized;
  }

  Future started() async {
    final canAuth = await userService.canAuthenticate();
    state = canAuth ? AuthenticationState.allowed : AuthenticationState.denied;
  }

  @action
  void loggedIn() {
    state = AuthenticationState.authenticated;
  }

  @action
  void inactive() {
    state = AuthenticationState.unauthenticated;
  }

  @action
  void active() {
    state = AuthenticationState.active;
  }

  @action
  void loggedOut() {
    state = AuthenticationState.uninitialized;
  }
}
