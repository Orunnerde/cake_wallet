package com.cakewallet.wallet.monero;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class TransactionHistory {
    long id;

    TransactionHistory(long id) {
        this.id = id;
    }

    public int count() {
        return countJNI();
    }

    public List<TransactionInfo> getAll() {
        return Arrays.asList(getAllTransactionsJNI());

//        long[] _transactions = getAllJNI();
//        ArrayList<TransactionInfo> transactions = new ArrayList<TransactionInfo>();
//
//        for (int i = 0; i < _transactions.length; i++) {
//            Long id = _transactions[i];
//            TransactionInfo tx = new TransactionInfo(id);
//            transactions.add(tx);
//        }
//
//        return transactions;
    }

    public TransactionInfo getByIndex(int index) {
        return new TransactionInfo();
    }

    public void refresh() { refreshJNI(); }

    private native int countJNI();

    private native long[] getAllJNI();

    private native long getByIndexJNI(int index);

    private native void refreshJNI();

    private native TransactionInfo[] getAllTransactionsJNI();
}
