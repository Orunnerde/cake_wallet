package com.cakewallet.wallet.monero;

import com.cakewallet.wallet.monero.WalletListener;

import java.io.StringReader;

public class Wallet {
//    static {
//        System.loadLibrary("cwmonero_lib");
//    }

    private static native String displayAmountJNI(long amount);

    public static String displayAmount(long amount) {
        return displayAmountJNI(amount);
    }

    public long id;
    public long listenerId;

    static WalletListener walletListener;

    public Wallet(long id) {
        this.id = id;
        listenerId = setListenerJNI();
    }

    public static void setListener(WalletListener walletListener) {
        Wallet.walletListener = walletListener;
    }

    public String getSeed() {
        return getSeedJNI();
    }

    public String getFilename() {
        return getFilemameJNI();
    }

    public String getName() {
        String[] splitted = getFilename().split("/");

        if (splitted.length <= 0) {
            return "";
        }

        return splitted[splitted.length - 1];
    }

    public String getAddress() {
        return getAddress(0, 0);
    }

    public String getBalance() {
        return getBalance(0);
    }

    public String getBalance(long accountIndex) {
        long balance = getBalanceRaw(accountIndex);
        return displayAmount(balance);
    }

    public String getUnlockedBalance() {
        return getUnlockedBalance(0);
    }

    public String getUnlockedBalance(long accountIndex) {
        long balance = getUnlockedBalanceRaw(accountIndex);
        return displayAmount(balance);
    }

    public long getBalanceRaw() {
        return getBalanceRaw(0);
    }

    public long getBalanceRaw(long accountIndex) {
        return getBalanceJNI(accountIndex);
    }

    public long getUnlockedBalanceRaw() {
        return getUnlockedBalanceRaw(0);
    }

    public long getUnlockedBalanceRaw(long accountIndex) {
        return getUnlockedBalanceJNI(accountIndex);
    }

    public String getAddress(long accountIndex, long addressIndex) {
        return getAddressJNI(accountIndex, addressIndex);
    }

    public boolean getIsConnected() { return getIsConnectedJNI(); }

    public void connectToNode(String uri, String login, String password, boolean useSSL, boolean isLightWallet) {
        setNodeAddressJNI(uri, login, password, useSSL, isLightWallet);
        connectToNodeJNI();
    }

    public void startSync() {
        startRefreshAsyncJNI();
    }

    public long getCurrentHeight() {
        return getCurrentHeightJNI();
    }

    public long getNodeHeight() {
        return getNodeHeightJNI();
    }

    public void setRefreshFromBlockHeight(long height) {
        setRefreshFromBlockHeightJNI(height);
    }

    public void setRecoveringFromSeed(boolean isRecovery) {
        setRecoveringFromSeedJNI(isRecovery);
    }

    public void store() {
        storeJNI("");
    }

    public PendingTransaction createTransaction(String address, String paymentId, String amount, int priority, int accountIndex) {
        long id = createTransactionJNI(address, paymentId, amount, priority, accountIndex);
        return new PendingTransaction(id);
    }

    public TransactionHistory history() {
        long id = transactionHistoryJNI();
        return new TransactionHistory(id);
    }

    public Subaddress subaddress() {
        long id = subaddressJNI();
        return new Subaddress(id);
    }

    public void moneySpent(String txId, long amount) {
        if (walletListener != null) {
            walletListener.moneySpent(txId, amount);
        }
    }

    public void moneyReceived(String txId, long amount) {
        if (walletListener != null) {
            walletListener.moneyReceived(txId, amount);
        }
    }

    public void unconfirmedMoneyReceived(String txId, long amount) {
        if (walletListener != null) {
            walletListener.unconfirmedMoneyReceived(txId, amount);
        }
    }

    public void newBlock(long height) {
        if (walletListener != null) {
            walletListener.newBlock(height);
        }
    }

    public void refreshed() {
        if (walletListener != null) {
            walletListener.refreshed();
        }
    }

    public void updated() {
        if (walletListener != null) {
            walletListener.updated();
        }
    }

    private native String getSeedJNI();

    private native String getFilemameJNI();

    private native String getAddressJNI(long accountIndex, long addressIndex);

    private native long getBalanceJNI(long accountIndex);

    private native long getUnlockedBalanceJNI(long accountIndex);

    private native long getCurrentHeightJNI();

    private native long getNodeHeightJNI();

    private native boolean getIsConnectedJNI();

    private native long setListenerJNI();

    private native void setNodeAddressJNI(String uri, String login, String password, boolean useSSL, boolean isLightWallet);

    private native void connectToNodeJNI();

    private native void startRefreshAsyncJNI();

    private native long transactionHistoryJNI();

    private native long subaddressJNI();

    private native void setRefreshFromBlockHeightJNI(long height);

    private native void setRecoveringFromSeedJNI(boolean isRecovery);

    private native void storeJNI(String path);

    private native long createTransactionJNI(String address, String paymentId, String amount, int priority, int accountIndex);
}
