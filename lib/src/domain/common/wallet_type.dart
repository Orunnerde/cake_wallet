enum WalletType { MONERO, NONE }

String walletTypeToString(WalletType type) {
  switch (type) {
    case WalletType.MONERO:
      return 'Monero';
    default:
      return '';
  }
}