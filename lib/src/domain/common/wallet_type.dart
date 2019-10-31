enum WalletType { monero, none }

int serializeToInt(WalletType type) {
  switch (type) {
    case WalletType.monero:
      return 0;
    default:
      return -1;
  }
}

WalletType deserializeToInt(int raw) {
  switch (raw) {
    case 0:
      return WalletType.monero;
    default:
      return null;
  }
}

String walletTypeToString(WalletType type) {
  switch (type) {
    case WalletType.monero:
      return 'Monero';
    default:
      return '';
  }
}