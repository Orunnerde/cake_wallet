package com.cakewallet.wallet;

import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import io.flutter.plugin.common.BasicMessageChannel;
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

    private BasicMessageChannel balanceChannel;
    private BasicMessageChannel<ByteBuffer> walletHeightChannel;
    private BasicMessageChannel<ByteBuffer> syncStateChannel;
    private Handler mainHandler = new Handler(Looper.getMainLooper());

    private TransactionHistory getTransactionHistory() {
        return currentTransactionHistory;
    }

    private Subaddress getSubaddress() {
        return currentSubaddress;
    }

    private Account getAccount() { return currentAccount; }

    private Wallet getCurrentWallet() {
        return currentWallet;
    }

    public void setCurrentWallet(Wallet wallet) {
        if (wallet == null) {
            return;
        }

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

    // MARK: WalletListener

    public void moneySpent(String txId, long amount) {
        System.out.println("moneySpent callback");

        if (balanceChannel == null || getCurrentWallet() == null) {
            return;
        }

        mainHandler.post(() -> balanceChannel.send(null));
    }

    public void moneyReceived(String txId, long amount) {
        System.out.println("moneyReceived callback");

        if (balanceChannel == null || getCurrentWallet() == null) {
            return;
        }


        mainHandler.post(() -> balanceChannel.send(null));
    }

    public void unconfirmedMoneyReceived(String txId, long amount) {
        System.out.println("unconfirmedMoneyReceived callback");

        if (balanceChannel == null || getCurrentWallet() == null) {
            return;
        }

        mainHandler.post(() -> balanceChannel.send(null));
    }

    public void newBlock(long height) {
        if (walletHeightChannel == null || getCurrentWallet() == null) {
            return;
        }

        ByteBuffer buffer = ByteBuffer.allocateDirect(8);
        buffer.putLong(height);


        mainHandler.post(() -> walletHeightChannel.send(buffer));
    }

    public void refreshed() {
        if (syncStateChannel == null || getCurrentWallet() == null) {
            return;
        }

        mainHandler.post(() -> syncStateChannel.send(refreshedEmptyResponse));
    }

    public void updated() {
        if (syncStateChannel == null || getCurrentWallet() == null) {
            return;
        }

        mainHandler.post(() -> syncStateChannel.send(refreshedEmptyResponse));
    }

    // MARK: Wallet

    private void createTransaction(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            String address = call.argument("address");
            String paymentId = call.argument("paymentId");
            String amount = call.argument("amount");
            int priority = call.argument("priority");
            int accountIndex = call.argument("accountIndex");

            try {
                PendingTransaction transaction = getCurrentWallet().createTransaction(address, paymentId, amount, priority, accountIndex);
                Thread.currentThread().setPriority(8); // FIXME: Unnamed constant
                HashMap<String, String> tx = new HashMap<String, String>();
                tx.put("id", String.valueOf(transaction.id));
                tx.put("amount", transaction.getAmount());
                tx.put("fee", transaction.getFee());
                tx.put("hash", transaction.getHash());
                mainHandler.post(() -> result.success(tx));
            } catch (Exception e) {
                mainHandler.post(() -> result.error("TRANSACTION_CREATION_ERROR", e.getMessage(), null));
            }
        });
    }

    private void commitTransaction(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            long id = call.argument("id");

            try {
                PendingTransaction transaction = new PendingTransaction(id);
                transaction.commit();
                mainHandler.post(() -> result.success(null));
                mainHandler.post(() -> balanceChannel.send(null));
            } catch (Exception e) {
                mainHandler.post(() -> result.error("TRANSACTION_COMMIT_ERROR", e.getMessage(), null));
            }
        });
    }

    private void store(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            getCurrentWallet().store();
            mainHandler.post(() -> result.success(null));
        });
    }

    private void getCurrentHeight(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            long height = getCurrentWallet().getCurrentHeight();
            mainHandler.post(() -> result.success(height));
        });
    }

    private void getNodeHeight(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            long height = getCurrentWallet().getNodeHeight();
            mainHandler.post(() -> result.success(height));
        });
    }

    private void getBalance(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            long accountIndex = Long.valueOf((int) call.argument("account_index"));
            String balance = getCurrentWallet().getBalance(accountIndex);
            mainHandler.post(() -> result.success(balance));
        });
    }

    private void getUnlockedBalance(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            long accountIndex = Long.valueOf((int) call.argument("account_index"));
            String balance = getCurrentWallet().getUnlockedBalance(accountIndex);
            mainHandler.post(() -> result.success(balance));
        });
    }

    private void getName(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            String name = getCurrentWallet().getName();
            mainHandler.post(() -> result.success(name));
        });
    }

    private void getFilename(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            String filename = getCurrentWallet().getFilename();
            mainHandler.post(() -> result.success(filename));
        });
    }

    private void getSeed(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            String seed = getCurrentWallet().getSeed();
            mainHandler.post(() -> result.success(seed));
        });
    }

    private void getKeys(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            MoneroWalletKeys _keys= getCurrentWallet().getKeys();
            HashMap<String, String> keys = new HashMap<>();

            keys.put("publicViewKey", String.valueOf(_keys.publicViewKey));
            keys.put("privateViewKey", String.valueOf(_keys.privateViewKey));
            keys.put("publicSpendKey", String.valueOf(_keys.publicSpendKey));
            keys.put("privateSpendKey", String.valueOf(_keys.privateSpendKey));

                mainHandler.post(() -> result.success(keys));
        });
    }

    private void getAddress(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            String address = getCurrentWallet().getAddress();
            mainHandler.post(() -> result.success(address));
        });
    }

    private void getIsConnected(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            boolean isConnected = getCurrentWallet().getIsConnected();
            mainHandler.post(() -> result.success(isConnected));
        });
    }

    private void connectToNode(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
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

    private void startSync(MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            currentWallet.startSync();
            mainHandler.post(() -> result.success(null));
        });
    }

    private void setRecoveringFromSeed(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            boolean isRecovering = true; //call.argument("isRecovering");
            getCurrentWallet().setRecoveringFromSeed(isRecovering);
            mainHandler.post(() -> result.success(null));
        });
    }

    private void setRefreshFromBlockHeight(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            long height = call.argument("height");
            getCurrentWallet().setRefreshFromBlockHeight(height);
            mainHandler.post(() -> result.success(null));
        });
    }

    private void close(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            boolean isClosed = moneroWalletsManager.close(getCurrentWallet(), true);

            if (isClosed) {
                currentWallet = null;
                currentSubaddress = null;
                currentTransactionHistory = null;
                mainHandler.post(() -> result.success(null));
            } else {
                mainHandler.post(() -> result.error("CLOSE_WALLET_ERROR", "Cannot close the wallet", null));
            }
        });
    }

    // MARK: TransactionHistory

    private void getAll(MethodCall call, MethodChannel.Result result) {
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

            mainHandler.post(() -> result.success(transactions));
        });
    }

    private void getByIndex(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int index = call.argument("index");
            TransactionInfo transaction = getTransactionHistory().getByIndex(index);
            mainHandler.post(() -> result.success(transaction));
        });
    }


    private void count(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int count = getTransactionHistory().count();
            mainHandler.post(() -> result.success(count));
        });
    }

    private void refresh(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            getTransactionHistory().refresh();
            mainHandler.post(() -> result.success(null));
        });
    }

    private void isNeedToRefresh(MethodCall call, MethodChannel.Result result) {
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
            mainHandler.post(() -> result.success(needToRefresh));
        });
    }

    // MARK: Subaddress

    private void getAllSubaddresses(MethodCall call, MethodChannel.Result result) {
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

            mainHandler.post(() -> result.success(subaddresses));
        });
    }

    private void refreshSubaddresses(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int account = call.argument("accountIndex");
            getSubaddress().refresh(account);
            mainHandler.post(() -> result.success(null));
        });
    }

    private void addSubaddress(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int account = call.argument("accountIndex");
            String label = call.argument("label");
            getSubaddress().add(account, label);
            mainHandler.post(() -> result.success(null));
        });
    }

    private void setLabelSubaddress(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int account = call.argument("accountIndex");
            int addressIndex = call.argument("addressIndex");
            String label = call.argument("label");
            getSubaddress().setLabel(account, addressIndex, label);
            mainHandler.post(() -> result.success(null));
        });
    }

    // MARK: Account

    private void getAllAccounts(MethodCall call, MethodChannel.Result result) {
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

            mainHandler.post(() -> result.success(accounts));
        });
    }

    private void refreshAccounts(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            getAccount().refresh();
            mainHandler.post(() -> result.success(null));
        });
    }

    private void addAccount(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            String label = call.argument("label");
            getAccount().add(label);
            mainHandler.post(() -> result.success(null));
        });
    }

    private void setLabelAccount(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            int account = call.argument("accountIndex");
            String label = call.argument("label");
            getAccount().setLabel(account, label);
            mainHandler.post(() -> result.success(null));
        });
    }
}