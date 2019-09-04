import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletEvent extends Equatable {
  WalletEvent([List props = const <dynamic>[]]) : super(props);
}
