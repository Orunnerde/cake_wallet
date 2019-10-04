import 'package:flutter/foundation.dart';

abstract class ExchangeTradeState {}

class ExchangeTradeStateInitial extends ExchangeTradeState {}

class TradeIsCreating extends ExchangeTradeState {}

class TradeIsCreatedSuccessfully extends ExchangeTradeState {}

class TradeIsCreatedFailure extends ExchangeTradeState {
  final String error;

  TradeIsCreatedFailure({@required this.error});
}