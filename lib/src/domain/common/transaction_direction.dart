enum TransactionDirection { INCOMING, OUTGOING }

TransactionDirection parseTransactionDirectionFromInt(int raw) {
  switch (raw) {
    case 0: return TransactionDirection.INCOMING;
    case 1: return TransactionDirection.OUTGOING;
    default: return null;
  }
}

TransactionDirection parseTransactionDirectionFromNumber(String raw) {
  switch (raw) {
    case "0": return TransactionDirection.INCOMING;
    case "1": return TransactionDirection.OUTGOING;
    default: return null;
  }
}