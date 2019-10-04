package com.cakewallet.wallet;

import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.cakewallet.wallet.monero.Account;
import com.cakewallet.wallet.monero.AccountRow;
import com.cakewallet.wallet.monero.MoneroWalletKeys;
import com.cakewallet.wallet.monero.PendingTransaction;
import com.cakewallet.wallet.monero.Subaddress;
import com.cakewallet.wallet.monero.SubaddressRow;
import com.cakewallet.wallet.monero.TransactionHistory;
import com.cakewallet.wallet.monero.TransactionInfo;
import com.cakewallet.wallet.monero.Wallet;

import com.cakewallet.wallet.monero.WalletListener;
import com.cakewallet.wallet.monero.WalletManager;

public class MoneroWalletHandler implements WalletListener {
    static final String MONERO_WALLET_CHANNEL = "com.cakewallet.wallet/monero-wallet";

    private static Wallet currentWallet;
    private static TransactionHistory currentTransactionHistory;
    private static Subaddress currentSubaddress;
    private static Account currentAccount;

    private static final WalletManager moneroWalletsManager = new WalletManager();

    private static ByteBuffer refreshedEmptyResponse = ByteBuffer.allocateDirect(4);


    TransactionHistory getTransactionHistory() {
        return currentTransactionHistory;
    }

    Subaddress getSubaddress() {
        return currentSubaddress;
    }

    Account getAccount() { return currentAccount; }

    Wallet getCurrentWallet() {
        return currentWallet;
    }

    public void setCurrentWallet(Wallet wallet) {
        currentWallet = wallet;
        setCurrentTransactionHistory(currentWallet.history());
        setCurrentSubaddress(currentWallet.subaddress());
        setCurrentAccount(currentWallet.account());
    }

    void setCurrentTransactionHistory(TransactionHistory history) {
        currentTransactionHistory = history;
    }

    void setCurrentSubaddress(Subaddress subaddress) {
        currentSubaddress = subaddress;
    }

    void setCurrentAccount(Account account) { currentAccount = account; }

    private BasicMessageChannel balanceChannel;
    private BasicMessageChannel<ByteBuffer> walletHeightChannel;
    private BasicMessageChannel<ByteBuffer> syncStateChannel;

    public void setBalanceChannel(BasicMessageChannel balanceChannel) {
        this.balanceChannel = balanceChannel;
    }

    public void setWalletHeightChannel(BasicMessageChannel<ByteBuffer> heightChannel) {
        this.walletHeightChannel = heightChannel;
    }

    public void setSyncStateChannel(BasicMessageChannel<ByteBuffer> syncStateChannel) {
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
                case "getIsConnected":
                    getIsConnected(call, result);
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
                case "getAllSubaddresses":
                    getAllSubaddresses(call, result);
                    break;
                case "refreshSubaddresses":
                    refreshSubaddresses(call, result);
                    break;
                case "addSubaddress":
                    addSubaddress(call, result);
                    break;
                case "setSubaddressLabel":
                    setLabelSubaddress(call, result);
                    break;
                case "getAllAccounts":
                    getAllAccounts(call, result);
                    break;
                case "refreshAccounts":
                    refreshAccounts(call, result);
                    break;
                case "addAccount":
                    addAccount(call, result);
                    break;
                case "setLabelAccount":
                    setLabelAccount(call, result);
                    break;
                case "setRecoveringFromSeed":
                    setRecoveringFromSeed(call, result);
                    break;
                case "setRefreshFromBlockHeight":
                    setRefreshFromBlockHeight(call, result);
                    break;
                case "close":
                    close(call, result);
                    break;
                case "isNeedToRefresh":
                    isNeedToRefresh(call, result);
                    break;
                case "getKeys":
                    getKeys(call, result);
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
                Thread.currentThread().setPriority(8); // FIXME: Unnamed constant
                HashMap<String, String> tx = new HashMap<String, String>();
                tx.put("id", String.valueOf(transaction.id));
                tx.put("amount", transaction.getAmount());
                tx.put("fee", transaction.getFee());
                mainHandler.post(() -> result.success(tx));
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

            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    public void getCurrentHeight(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
            long height = getCurrentWallet().getCurrentHeight();
            result.success(height);
//        });
    }

    public void getNodeHeight(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
            long height = getCurrentWallet().getNodeHeight();
            result.success(height);
//        });
    }

    public void getBalance(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
            long accountIndex = Long.valueOf((int) call.argument("account_index"));
            String balance = getCurrentWallet().getBalance(accountIndex);
            result.success(balance);
//        });
    }

    public void getUnlockedBalance(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
            long accountIndex = Long.valueOf((int) call.argument("account_index"));
            String balance = getCurrentWallet().getUnlockedBalance(accountIndex);
            result.success(balance);
//        });
    }

    public void getName(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
            String name = getCurrentWallet().getName();
            result.success(name);
//        });
    }

    public void getFilename(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
            String filename = getCurrentWallet().getFilename();
            result.success(filename);
//        });
    }

    public void getSeed(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
            String seed = getCurrentWallet().getSeed();
            result.success(seed);
//        });
    }

    public void getKeys(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
        MoneroWalletKeys _keys= getCurrentWallet().getKeys();
        HashMap<String, String> keys = new HashMap<>();

        keys.put("publicViewKey", String.valueOf(_keys.publicViewKey));
        keys.put("privateViewKey", String.valueOf(_keys.privateViewKey));
        keys.put("publicSpendKey", String.valueOf(_keys.publicSpendKey));
        keys.put("privateSpendKey", String.valueOf(_keys.privateSpendKey));

        result.success(keys);
//        });
    }

    public void getAddress(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
            String address = getCurrentWallet().getAddress();
            result.success(address);
//        });
    }

    public void getIsConnected(MethodCall call, MethodChannel.Result result) {
//        AsyncTask.execute(() -> {
            boolean isConnected = getCurrentWallet().getIsConnected();
            result.success(isConnected);
//        });
    }

    public void connectToNode(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            Handler mainHandler = new Handler(Looper.getMainLooper());

            try {
                String uri = call.argument("uri");
                String login = call.argument("login");
                String password = call.argument("password");
                boolean useSSL = false;//(boolean) call.argument("use_ssl");
                boolean isLightWallet = false; // (boolean) call.argument("is_light_wallet");
                currentWallet.connectToNode(uri, login, password, useSSL, isLightWallet);

                mainHandler.post(() -> result.success(null));
            } catch (Exception e) {
                mainHandler.post(() -> result.error("CONNECTION_ERROR", e.getMessage(), null));
            }
        });
    }

    public void startSync(MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            currentWallet.startSync();

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(null));
        });
    }

    public void setRecoveringFromSeed(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            boolean isRecovering = true; //call.argument("isRecovering");
            getCurrentWallet().setRecoveringFromSeed(isRecovering);
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    public void setRefreshFromBlockHeight(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            long height = call.argument("height");
            getCurrentWallet().setRefreshFromBlockHeight(height);
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    public void close(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            boolean isClosed = moneroWalletsManager.close(getCurrentWallet(), true);

            if (isClosed) {
                result.success(true);
                currentWallet = null;
                currentSubaddress = null;
                currentTransactionHistory = null;

                new Handler(Looper.getMainLooper())
                        .post(() -> result.success(null));
            } else {
                new Handler(Looper.getMainLooper())
                        .post(() -> result.error("CLOSE_WALLET_ERROR", "Cannot close the wallet", null));
            }
        });
    }

    // MARK: TransactionHistory

    public void getAll(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            List<TransactionInfo> _transactions = getTransactionHistory().getAll();
            List<HashMap<String, String>> transactions = new ArrayList<HashMap<String, String>>();

            for (int i = 0; i < _transactions.size(); i++) {
                TransactionInfo tx = _transactions.get(i);
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
                txMap.put("accountIndex", String.valueOf(tx.accountIndex));

                transactions.add(txMap);
            }

            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(transactions));
        });
    }

    public void getByIndex(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int index = call.argument("index");
            TransactionInfo transaction = getTransactionHistory().getByIndex(index);
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(transaction));
        });
    }


    public void count(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int count = getTransactionHistory().count();
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(count));
        });
    }

    public void refresh(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            getTransactionHistory().refresh();
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    public void isNeedToRefresh(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int preCount = getTransactionHistory().count();
            List<TransactionInfo> preTransactons = getTransactionHistory().getAll();
            getTransactionHistory().refresh();
            int count = getTransactionHistory().count();
            List<TransactionInfo> transactons = getTransactionHistory().getAll();

            if (preCount < count) {
                new Handler(Looper.getMainLooper())
                        .post(() -> result.success(true));
                return;
            }

            final boolean needToRefresh = preTransactons.containsAll(transactons);

            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(needToRefresh));
        });
    }

    // MARK: Subaddress

    public void getAllSubaddresses(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            List<SubaddressRow> _subaddresses = getSubaddress().getAll();
            List<HashMap<String, String>> subaddresses = new ArrayList<HashMap<String, String>>();

            for (int i = 0; i < _subaddresses.size(); i++) {
                SubaddressRow subaddress = _subaddresses.get(i);
                HashMap<String, String> subaddressMap = new HashMap<String, String>();

                subaddressMap.put("id", String.valueOf(subaddress.id));
                subaddressMap.put("label", subaddress.label);
                subaddressMap.put("address", subaddress.address);

                subaddresses.add(subaddressMap);
            }

            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(subaddresses));
        });
    }

    public void refreshSubaddresses(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int account = call.argument("accountIndex");
            getSubaddress().refresh(account);
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    public void addSubaddress(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int account = call.argument("accountIndex");
            String label = call.argument("label");
            getSubaddress().add(account, label);
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    public void setLabelSubaddress(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int account = call.argument("accountIndex");
            int addressIndex = call.argument("addressIndex");
            String label = call.argument("label");
            getSubaddress().setLabel(account, addressIndex, label);
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    // MARK: Account

    public void getAllAccounts(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            List<AccountRow> _accounts = getAccount().getAll();
            List<HashMap<String, String>> accounts = new ArrayList<HashMap<String, String>>();

            for (int i = 0; i < _accounts.size(); i++) {
                AccountRow account = _accounts.get(i);
                HashMap<String, String> accountMap = new HashMap<String, String>();

                accountMap.put("id", String.valueOf(account.id));
                accountMap.put("label", account.label);
                accountMap.put("address", account.address);

                accounts.add(accountMap);
            }

            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(accounts));
        });
    }

    public void refreshAccounts(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            getAccount().refresh();
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    public void addAccount(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            String label = call.argument("label");
            getAccount().add(label);
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    public void setLabelAccount(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int account = call.argument("accountIndex");
            String label = call.argument("label");
            getAccount().setLabel(account, label);
            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(null));
        });
    }

    // MARK: WalletListener

    public void moneySpent(String txId, long amount) {
        if (balanceChannel == null || getCurrentWallet() == null) {
            return;
        }

        new Handler(Looper.getMainLooper())
                .post(() -> balanceChannel.send(null));
    }

    public void moneyReceived(String txId, long amount) {
        if (balanceChannel == null || getCurrentWallet() == null) {
            return;
        }

        new Handler(Looper.getMainLooper())
                .post(() -> balanceChannel.send(null));
    }

    public void unconfirmedMoneyReceived(String txId, long amount) {
        if (balanceChannel == null || getCurrentWallet() == null) {
            return;
        }

        new Handler(Looper.getMainLooper())
                .post(() -> balanceChannel.send(null));
    }

    public void newBlock(long height) {
        if (walletHeightChannel == null || getCurrentWallet() == null) {
            return;
        }

        ByteBuffer buffer = ByteBuffer.allocateDirect(8);
        buffer.putLong(height);


        new Handler(Looper.getMainLooper())
                .post(() -> walletHeightChannel.send(buffer));
    }

    public void refreshed() {
        if (syncStateChannel == null || getCurrentWallet() == null) {
            return;
        }

        new Handler(Looper.getMainLooper())
                .post(() -> syncStateChannel.send(refreshedEmptyResponse));
    }

    public void updated() {
        if (syncStateChannel == null || getCurrentWallet() == null) {
            return;
        }

        new Handler(Looper.getMainLooper())
                .post(() -> syncStateChannel.send(refreshedEmptyResponse));
    }
}