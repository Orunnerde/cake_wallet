enum WalletType { monero, none }

String walletTypeToString(WalletType type) {
  switch (type) {
    case WalletType.monero:
      return 'Monero';
    default:
      return '';
  }
}