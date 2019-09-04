package com.cakewallet.wallet;

import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.cakewallet.wallet.monero.PendingTransaction;
import com.cakewallet.wallet.monero.TransactionHistory;
import com.cakewallet.wallet.monero.TransactionInfo;
import com.cakewallet.wallet.monero.Wallet;

import com.cakewallet.wallet.monero.WalletListener;

public class MoneroWalletHandler implements WalletListener {
    static final String MONERO_WALLET_CHANNEL = "com.cakewallet.wallet/monero-wallet";

    private static Wallet currentWallet;
    private static TransactionHistory currentTransactionHistory;

    public static Wallet getCurrentWallet() {
        return currentWallet;
    }

    public static TransactionHistory getTransactionHistory() {
        return currentTransactionHistory;
    }

    public static void setCurrentWallet(Wallet wallet) {
        currentWallet = wallet;
        setCurrentWallet(currentWallet.history());
    }

    public static void setCurrentWallet(TransactionHistory history) {
        currentTransactionHistory = history;
    }

    private BasicMessageChannel balanceChannel;
    private BasicMessageChannel walletHeightChannel;
    private BasicMessageChannel syncStateChannel;

    public void setBalanceChannel(BasicMessageChannel balanceChannel) {
        this.balanceChannel = balanceChannel;
    }

    public void setWalletHeightChannel(BasicMessageChannel heightChannel) {
        this.walletHeightChannel = heightChannel;
    }

    public void setSyncStateChannel(BasicMessageChannel syncStateChannel) {
        this.syncStateChannel = syncStateChannel;
    }

    public void handle(MethodCall call, MethodChannel.Result result) {
        if (getCurrentWallet() == null) {
            result.error("NO_WALLET", "Current wallet not set for monero", null);
            return;
        }

        try {
            switch (call.method) {
                case "getFilename":
                    getFilename(call, result);
                    break;
                case "getName":
                    getName(call, result);
                    break;
                case "getSeed":
                    getSeed(call, result);
                    break;
                case "getAddress":
                    getAddress(call, result);
                    break;
                case "connectToNode":
                    connectToNode(call, result);
                    break;
                case "startSync":
                    startSync(result);
                    break;
                case "getBalance":
                    getBalance(call, result);
                    break;
                case "getUnlockedBalance":
                    getUnlockedBalance(call, result);
                    break;
                case "getCurrentHeight":
                    getCurrentHeight(call, result);
                    break;
                case "getNodeHeight":
                    getNodeHeight(call, result);
                    break;
                case "store":
                    store(call, result);
                    break;
                case "createTransaction":
                    createTransaction(call, result);
                    break;
                case "getAllTransactions":
                    getAll(call, result);
                    break;
                case "getTransactionsCount":
                    count(call, result);
                    break;
                case "getTransactionByIndex":
                    getByIndex(call, result);
                    break;
                case "refreshTransactionHistory":
                    refresh(call, result);
                    break;
                case "commitTransaction":
                    commitTransaction(call, result);
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        } catch (Exception e) {
            result.error("UNCAUGHT_ERROR", e.getMessage(), null);
        }
    }

    public void createTransaction(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            String address = call.argument("address");
            String paymentId = call.argument("paymentId");
            String amount = call.argument("amount");
            int priority = call.argument("priority");
            int accountIndex = call.argument("accountIndex");

            Handler mainHandler = new Handler(Looper.getMainLooper());

            try {
                PendingTransaction transaction = getCurrentWallet().createTransaction(address, paymentId, amount, priority, accountIndex);
                mainHandler.post(() -> result.success(transaction.id));
            } catch (Exception e) {
                mainHandler.post(() -> result.error("TRANSACTION_CREATION_ERROR", e.getMessage(), null));
            }
        });
    }

    public void commitTransaction(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            long id = call.argument("id");

            Handler mainHandler = new Handler(Looper.getMainLooper());

            try {
                PendingTransaction transaction = new PendingTransaction(id);
                transaction.commit();
                mainHandler.post(() -> result.success(null));
            } catch (Exception e) {
                mainHandler.post(() -> result.error("TRANSACTION_COMMIT_ERROR", e.getMessage(), null));
            }
        });
    }

    public void store(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            getCurrentWallet().store();

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(null));
        });
    }

    public void getCurrentHeight(MethodCall call, MethodChannel.Result result) {
        long height = getCurrentWallet().getCurrentHeight();
        result.success(height);
    }

    public void getNodeHeight(MethodCall call, MethodChannel.Result result) {
        long height = getCurrentWallet().getNodeHeight();
        result.success(height);
    }

    public void getBalance(MethodCall call, MethodChannel.Result result) {
        long accountIndex = Long.valueOf((int) call.argument("account_index"));
        String balance = getCurrentWallet().getBalance(accountIndex);
        result.success(balance);
    }

    public void getUnlockedBalance(MethodCall call, MethodChannel.Result result) {
        long accountIndex = Long.valueOf((int) call.argument("account_index"));
        String balance = getCurrentWallet().getUnlockedBalance(accountIndex);
        result.success(balance);
    }

    public void getName(MethodCall call, MethodChannel.Result result) {
        String name = getCurrentWallet().getName();
        result.success(name);
    }

    public void getFilename(MethodCall call, MethodChannel.Result result) {
        String filename = getCurrentWallet().getFilename();
        result.success(filename);
    }

    public void getSeed(MethodCall call, MethodChannel.Result result) {
        String seed = getCurrentWallet().getSeed();
        result.success(seed);
    }

    public void getAddress(MethodCall call, MethodChannel.Result result) {
        String address = getCurrentWallet().getAddress();
        result.success(address);
    }

    public void connectToNode(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            String uri = call.argument("uri");
            String login = call.argument("login");
            String password = call.argument("password");
            boolean useSSL = false;//(boolean) call.argument("use_ssl");
            boolean isLightWallet = false; // (boolean) call.argument("is_light_wallet");
            currentWallet.connectToNode(uri, login, password, useSSL, isLightWallet);

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(null));
        });
    }

    public void startSync(MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            currentWallet.startSync();

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(null));
        });
    }

    // MARK: TransactionHistory

    public void getAll(MethodCall call, MethodChannel.Result result) {
        List<TransactionInfo> _transactions = getTransactionHistory().getAll();
        List<HashMap<String, String>> transactions = new ArrayList<HashMap<String, String>>();

        for (int i = 0; i < _transactions.size(); i++) {
            TransactionInfo tx = _transactions.get(i);

//            if (tx == null) {
//                continue;
//            }

            HashMap<String, String> txMap = new HashMap<String, String>();

            txMap.put("direction", String.valueOf(tx.direction));
            txMap.put("isPending", String.valueOf(tx.isPending));
            txMap.put("isFailed", String.valueOf(tx.isFailed));
            txMap.put("height", String.valueOf(tx.blockHeight));
            txMap.put("amount", tx.formattedAmount());
            txMap.put("fee", String.valueOf(tx.fee));
            txMap.put("timestamp", String.valueOf(tx.timestamp));
            txMap.put("paymentId", tx.paymentId);
            txMap.put("hash", tx.hash);

            transactions.add(txMap);
        }

        result.success(transactions);
    }

    public void getByIndex(MethodCall call, MethodChannel.Result result) {
        int index = call.argument("index");
        TransactionInfo transaction = getTransactionHistory().getByIndex(index);

        result.success(transaction);
    }


    public void count(MethodCall call, MethodChannel.Result result) {
        int count = getTransactionHistory().count();
        result.success(count);
    }

    public void refresh(MethodCall call, MethodChannel.Result result) {
        getTransactionHistory().refresh();
        result.success(null);
    }

    // MARK: WalletListener

    public void moneySpent(String txId, long amount) {
        if (balanceChannel == null) {
            return;
        }

        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> balanceChannel.send(null));
    }

    public void moneyReceived(String txId, long amount) {
        if (balanceChannel == null) {
            return;
        }

        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> balanceChannel.send(null));
    }

    public void unconfirmedMoneyReceived(String txId, long amount) {
        if (balanceChannel == null) {
            return;
        }

        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> balanceChannel.send(null));
    }

    public void newBlock(long height) {
        if (walletHeightChannel == null) {
            return;
        }

        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> walletHeightChannel.send(Long.toString(height)));
    }

    public void refreshed() {
        if (syncStateChannel == null) {
            return;
        }

        System.out.print("Refreshed");

        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> syncStateChannel.send("refreshed"));
    }

    public void updated() {
        if (syncStateChannel == null) {
            return;
        }

        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(() -> syncStateChannel.send("updated"));
    }
}