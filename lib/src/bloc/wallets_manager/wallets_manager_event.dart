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
      : super([name]);
}
