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
