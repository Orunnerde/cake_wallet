String calculateFiatAmountRaw({double price, double cryptoAmount}) {
  if (price == null) {
    return '0.0';
  }

  final result = price * cryptoAmount;

  if (result == 0.0) {
    return '0.0';
  }

  return result > 0.01 ? result.toStringAsFixed(2) : '< 0.01';
}