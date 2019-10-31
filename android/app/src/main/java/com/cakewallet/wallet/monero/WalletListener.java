package com.cakewallet.wallet.monero;

public interface WalletListener {
    void moneySpent(String txId, long amount);
    void moneyReceived(String txId, long amount);
    void unconfirmedMoneyReceived(String txId, long amount);
    void newBlock(long height);
    void refreshed();
    void updated();
}