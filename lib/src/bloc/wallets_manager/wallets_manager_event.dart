import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletsManagerEvent extends Equatable {
  WalletsManagerEvent([List props = const <dynamic>[]]) : super(props);
}

class CreateWallet extends WalletsManagerEvent {
  final String name;

  CreateWallet({@required this.name}) : super([name]);
}

class RestoreFromSeedWallet extends WalletsManagerEvent {
  final String name;
  final String seed;
  final int restoreHeight;

  RestoreFromSeedWallet(
      {@required this.name, @required this.seed, @required this.restoreHeight})
      : super([name, seed, restoreHeight]);
}


class RestoreFromKeysWallet extends WalletsManagerEvent {
  final String name;
  final String address;
  final String viewKey;
  final String spendKey;
  final int restoreHeight;

  RestoreFromKeysWallet(
      {@required this.name, @required this.address, @required this.viewKey, @required this.spendKey, @required this.restoreHeight})
      : super([name, address, viewKey, spendKey, restoreHeight]);
}