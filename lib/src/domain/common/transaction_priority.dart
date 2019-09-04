enum TransactionPriority { DEFAULT, LOW, MEDIUM, HIEGH, LAST }

String priorityToString(TransactionPriority priority) {
  switch (priority) {
    case TransactionPriority.LOW: return "Slow ";
    case TransactionPriority.DEFAULT: return "Regular";
    case TransactionPriority.MEDIUM: return "Medium";
    case TransactionPriority.HIEGH: return "Fast";
    case TransactionPriority.LAST: return "Fastest";
  }
}