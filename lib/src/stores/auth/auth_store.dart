import 'package:cake_wallet/src/stores/auth/auth_state.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import 'package:cake_wallet/src/stores/user/user_store_state.dart';

part 'auth_store.g.dart';

class AuthStore = AuthStoreBase with _$AuthStore;

abstract class AuthStoreBase with Store {
  @observable
  AuthState state;

  UserService _userService;

  AuthStoreBase({@required UserService userService}) {
    _userService = userService;
    state = AuthenticationStateInitial();
  }

  @action
  Future<void> auth({String pin}) async {
    state = AuthenticationInProgress();
    final isAuthenticated = await _userService.authenticate(pin);
    state = isAuthenticated
        ? AuthenticatedSuccessfully()
        : AuthenticationFailure(error: 'Wrong pin');
  }
}
