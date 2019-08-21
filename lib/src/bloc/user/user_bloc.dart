import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cake_wallet/src/user_service.dart';
import './user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserService _accountService = UserService();

  @override
  UserState get initialState => UserStateInitial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is SetPinCode) {
      try {
        await _accountService.setPassword(event.pin);
        yield PinCodeSetSuccesfully();
      } catch(e) {
        yield PinCodeSetFailed(msg: e.toString());
      }
    }
  }
}
