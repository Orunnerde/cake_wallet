import 'package:cake_wallet/src/domain/common/enumerable_item.dart';

class FiatCurrency extends EnumerableItem<String> with Serializable<String> {
  static final all = [
    FiatCurrency.aud,
    FiatCurrency.bgn,
    FiatCurrency.brl,
    FiatCurrency.cad,
    FiatCurrency.chf,
    FiatCurrency.cny,
    FiatCurrency.czk,
    FiatCurrency.eur,
    FiatCurrency.dkk,
    FiatCurrency.gbp,
    FiatCurrency.hkd,
    FiatCurrency.hrk,
    FiatCurrency.huf,
    FiatCurrency.idr,
    FiatCurrency.ils,
    FiatCurrency.inr,
    FiatCurrency.isk,
    FiatCurrency.jpy,
    FiatCurrency.krw,
    FiatCurrency.mxn,
    FiatCurrency.myr,
    FiatCurrency.nok,
    FiatCurrency.nzd,
    FiatCurrency.php,
    FiatCurrency.pln,
    FiatCurrency.ron,
    FiatCurrency.rub,
    FiatCurrency.sek,
    FiatCurrency.sgd,
    FiatCurrency.thb,
    FiatCurrency.usd,
    FiatCurrency.zar,
    FiatCurrency.vef
  ];

  static final aud = FiatCurrency(symbol: 'AUD');
  static final bgn = FiatCurrency(symbol: 'BGN');
  static final brl = FiatCurrency(symbol: 'BRL');
  static final cad = FiatCurrency(symbol: 'CAD');
  static final chf = FiatCurrency(symbol: 'CHF');
  static final cny = FiatCurrency(symbol: 'CNY');
  static final czk = FiatCurrency(symbol: 'CZK');
  static final eur = FiatCurrency(symbol: 'EUR');
  static final dkk = FiatCurrency(symbol: 'DKK');
  static final gbp = FiatCurrency(symbol: 'GBP');
  static final hkd = FiatCurrency(symbol: 'HKD');
  static final hrk = FiatCurrency(symbol: 'HRK');
  static final huf = FiatCurrency(symbol: 'HUF');
  static final idr = FiatCurrency(symbol: 'IDR');
  static final ils = FiatCurrency(symbol: 'ILS');
  static final inr = FiatCurrency(symbol: 'INR');
  static final isk = FiatCurrency(symbol: 'ISK');
  static final jpy = FiatCurrency(symbol: 'JPY');
  static final krw = FiatCurrency(symbol: 'KRW');
  static final mxn = FiatCurrency(symbol: 'MXN');
  static final myr = FiatCurrency(symbol: 'MYR');
  static final nok = FiatCurrency(symbol: 'NOK');
  static final nzd = FiatCurrency(symbol: 'NZD');
  static final php = FiatCurrency(symbol: 'PHP');
  static final pln = FiatCurrency(symbol: 'PLN');
  static final ron = FiatCurrency(symbol: 'RON');
  static final rub = FiatCurrency(symbol: 'RUB');
  static final sek = FiatCurrency(symbol: 'SEK');
  static final sgd = FiatCurrency(symbol: 'SGD');
  static final thb = FiatCurrency(symbol: 'THB');
  static final usd = FiatCurrency(symbol: 'USD');
  static final zar = FiatCurrency(symbol: 'ZAR');
  static final vef = FiatCurrency(symbol: 'VEF');

  FiatCurrency({String symbol}) : super(title: symbol, raw: symbol);
}
