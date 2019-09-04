import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cake_wallet/src/domain/services/user_service.dart';
import './user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserService accountService;

  UserBloc(this.accountService);

  @override
  UserState get initialState => UserStateInitial();

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is SetPinCode) {
      try {
        await accountService.setPassword(event.pin);
        yield PinCodeSetSuccesfully();
      } catch(e) {
        yield PinCodeSetFailed(msg: e.toString());
      }
    }
  }
}
