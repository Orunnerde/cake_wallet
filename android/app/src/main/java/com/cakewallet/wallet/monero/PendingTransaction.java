package com.cakewallet.wallet.monero;

public class PendingTransaction {
    public long id;

    public PendingTransaction(long id) {
        this.id = id;
    }

    public void commit() {
       commitJNI();
    }

    private native void commitJNI();
}
