import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletState extends Equatable {
  WalletState([List props = const <dynamic>[]]) : super(props);
}

class InitialWalletState extends WalletState {}
