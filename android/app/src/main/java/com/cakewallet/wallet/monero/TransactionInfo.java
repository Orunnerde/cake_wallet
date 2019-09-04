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

    public String formattedAmount() {
        return Wallet.displayAmount(amount);
    }
}
