import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletsManagerState extends Equatable {
  WalletsManagerState([List props = const <dynamic>[]]) : super(props);
}

class WalletsManagerStateInitial extends WalletsManagerState {}

class CreatingWallet extends WalletsManagerState {}
class WalletCreatedSuccessfully extends WalletsManagerState {}

class WalletCreatedFailed extends WalletsManagerState {
  String msg;
  WalletCreatedFailed(this.msg) : super([msg]);
}