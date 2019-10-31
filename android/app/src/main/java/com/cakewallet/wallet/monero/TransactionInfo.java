package com.cakewallet.wallet.monero;

public class TransactionInfo {
    public int direction;
    public boolean isPending;
    public boolean isFailed;
    public long amount;
    public long fee;
    public long blockHeight;
    public long timestamp;
    public String paymentId;
    public String hash;
    public int accountIndex;

    public String formattedAmount() {
        return Wallet.displayAmount(amount);
    }


    public boolean equals (TransactionInfo tx)  {
        if (this == tx) return true;
        if (this == null) return false;
        if (this.getClass() != tx.getClass()) return false;

        return hash == tx.hash && isPending == tx.isPending;
    }
}
