enum CryptoCurrency { xmr, btc, eth, ltc, bch, dash }

const cryptoCurrencies = [
  CryptoCurrency.xmr,
  CryptoCurrency.btc,
  CryptoCurrency.eth,
  CryptoCurrency.ltc,
  CryptoCurrency.bch,
  CryptoCurrency.dash
];

int serializeToInt(CryptoCurrency type) {
  switch (type) {
    case CryptoCurrency.xmr:
      return 0;
    case CryptoCurrency.btc:
      return 1;
    case CryptoCurrency.eth:
      return 2;
    case CryptoCurrency.ltc:
      return 3;
    case CryptoCurrency.bch:
      return 4;
    case CryptoCurrency.dash:
      return 5;
    default:
      return -1;
  }
}

CryptoCurrency deserializeToInt(int raw) {
  switch (raw) {
    case 0:
      return CryptoCurrency.xmr;
    case 1:
      return CryptoCurrency.btc;
    case 2:
      return CryptoCurrency.eth;
    case 3:
      return CryptoCurrency.ltc;
    case 4:
      return CryptoCurrency.bch;
    case 5:
      return CryptoCurrency.dash;
    default:
      return null;
  }
}

String cryptoCurrenctToString(CryptoCurrency type) {
  switch (type) {
    case CryptoCurrency.xmr:
      return 'XMR';
    case CryptoCurrency.btc:
      return 'BTC';
    case CryptoCurrency.eth:
      return 'ETH';
    case CryptoCurrency.ltc:
      return 'LTC';
    case CryptoCurrency.bch:
      return 'BCH';
    case CryptoCurrency.dash:
      return 'DASH';
    default:
      return null;
  }
}
