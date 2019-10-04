package com.cakewallet.wallet.monero;

public class PendingTransaction {
    public long id;

    public PendingTransaction(long id) {
        this.id = id;
    }

    public void commit() {
       commitJNI();
    }

    public String getAmount() { return Wallet.displayAmount(getAmountJNI()); }
    public String getFee() { return Wallet.displayAmount(getFeeJNI()); }
    public String getHash() { return getHashJNI(); }

    private native void commitJNI();
    private native long getAmountJNI();
    private native long getFeeJNI();
    private native String getHashJNI();
}
