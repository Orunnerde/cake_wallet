import 'dart:async';
import 'package:bloc/bloc.dart';
import './wallet.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  @override
  WalletState get initialState => InitialWalletState();

  @override
  Stream<WalletState> mapEventToState(
    WalletEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
