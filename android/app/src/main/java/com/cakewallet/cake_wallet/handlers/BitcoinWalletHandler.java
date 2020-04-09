package com.cakewallet.cake_wallet.handlers;

import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;

import com.google.common.util.concurrent.FutureCallback;
import com.google.common.util.concurrent.Futures;
import com.google.common.util.concurrent.MoreExecutors;

import org.bitcoinj.core.Address;
import org.bitcoinj.core.BlockChain;
import org.bitcoinj.core.Coin;
import org.bitcoinj.core.ECKey;
import org.bitcoinj.core.LegacyAddress;
import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.core.PeerAddress;
import org.bitcoinj.core.PeerGroup;
import org.bitcoinj.core.Transaction;
import org.bitcoinj.core.TransactionConfidence;
import org.bitcoinj.core.listeners.DownloadProgressTracker;
import org.bitcoinj.crypto.DeterministicKey;
import org.bitcoinj.params.MainNetParams;
import org.bitcoinj.net.discovery.DnsDiscovery;
import org.bitcoinj.script.Script;
import org.bitcoinj.store.SPVBlockStore;
import org.bitcoinj.wallet.DeterministicSeed;
import org.bitcoinj.wallet.SendRequest;
import org.bitcoinj.wallet.Wallet;
import org.checkerframework.checker.nullness.compatqual.NullableDecl;

import java.util.Map;

import java.io.File;
import java.nio.ByteBuffer;
import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BitcoinWalletHandler {
    public static final String BITCOIN_WALLET_CHANNEL = "com.cakewallet.cake_wallet/bitcoin-wallet";
    private static final int SYNCING_START = 1;
    private static final int SYNCING_IN_PROGRESS = 2;
    private static final int SYNCING_FINISHED = 0;
    private static final int NEED_TO_REFRESH = 0;

    private PeerGroup peerGroup;
    private BlockChain chain;
    private SPVBlockStore blockStore;
    private Wallet currentWallet;
    private SendRequest request;
    private DownloadProgressTracker tracker;
    private String path;
    private String password;
    private boolean isConnected = false;
    private BasicMessageChannel<ByteBuffer> progressChannel;
    private BasicMessageChannel<ByteBuffer> balanceChannel;
    private Handler mainHandler = new Handler(Looper.getMainLooper());

    public void setProgressChannel(BasicMessageChannel progressChannel) {
        this.progressChannel = progressChannel;
    }

    public void setBalanceChannel(BasicMessageChannel balanceChannel) {
        this.balanceChannel = balanceChannel;
    }

    private void setWalletListeners() {
        AsyncTask.execute(() -> {
            if (currentWallet != null) {
                currentWallet.addCoinsReceivedEventListener((wallet, tx, prevBalance, newBalance) -> {
                    ByteBuffer buffer = ByteBuffer.allocateDirect(4);
                    buffer.putInt(NEED_TO_REFRESH);

                    mainHandler.post(() -> balanceChannel.send(buffer));
                });

                currentWallet.addCoinsSentEventListener((wallet, tx, prevBalance, newBalance) -> {
                    ByteBuffer buffer = ByteBuffer.allocateDirect(4);
                    buffer.putInt(NEED_TO_REFRESH);

                    mainHandler.post(() -> balanceChannel.send(buffer));
                });
            }
        });
    }

    private void saveWalletToFile() throws Exception{
        File file = new File(path);

        currentWallet.encrypt(password);
        currentWallet.saveToFile(file);
        currentWallet.decrypt(password);
    }

    private void shutDownWallet(boolean isNeedToRefresh) throws Exception {
        if (peerGroup != null && peerGroup.isRunning()) {
            peerGroup.stop();
        }

        if (currentWallet != null) {
            File file = new File(path);
            currentWallet.encrypt(password);
            currentWallet.saveToFile(file);
            if (isNeedToRefresh) {
                currentWallet.decrypt(password);
            }
        }

        if (blockStore != null) {
            blockStore.close();
        }

        isConnected = false;

        peerGroup = null;
        chain = null;
        blockStore = null;
        tracker = null;
        if (!isNeedToRefresh) {
            currentWallet = null;
        }
    }

    private void installShutDownHook() {
        Runtime.getRuntime().addShutdownHook(new Thread() {
            @Override
            public void run() {
                try {
                    shutDownWallet(false);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        });
    }

    public boolean createWallet(String path, String password) throws Exception {
        this.path = path;
        this.password = password;

        NetworkParameters params = MainNetParams.get();

        currentWallet = Wallet.createDeterministic(params, Script.ScriptType.P2PKH);

        ECKey ecKey = new ECKey();
        currentWallet.importKey(ecKey);

        setWalletListeners();
        saveWalletToFile();
        installShutDownHook();

        return true;
    }

    public boolean openWallet(String path, String password) throws Exception {
        this.path = path;
        this.password = password;

        File file = new File(path);

        currentWallet = Wallet.loadFromFile(file);
        currentWallet.decrypt(password);

        setWalletListeners();
        installShutDownHook();

        return true;
    }

    public boolean restoreWalletFromSeed(String path, String password, String seed, String passphrase)
            throws Exception {
        this.path = path;
        this.password = password;

        NetworkParameters params = MainNetParams.get();
        long creationTime = 1409478661L;

        DeterministicSeed deterministicSeed = new DeterministicSeed(seed, null, passphrase, creationTime);
        currentWallet = Wallet.fromSeed(params, deterministicSeed, Script.ScriptType.P2PKH);

        setWalletListeners();
        saveWalletToFile();
        installShutDownHook();

        return true;
    }

    public boolean restoreWalletFromKey(String path, String password, String privateKey) throws Exception {
        this.path = path;
        this.password = password;

        NetworkParameters params = MainNetParams.get();

        DeterministicKey restoreKey = DeterministicKey.deserializeB58(privateKey, params);
        currentWallet = Wallet.fromWatchingKey(params, restoreKey, Script.ScriptType.P2PKH);

        setWalletListeners();
        saveWalletToFile();
        installShutDownHook();

        return true;
    }

    public void handle(MethodCall call, MethodChannel.Result result) {
        try {
            switch (call.method) {
                case "getAddress":
                    getAddress(call, result);
                    break;
                case "getUnlockedBalance":
                    getUnlockedBalance(call, result);
                    break;
                case "getFullBalance":
                    getFullBalance(call, result);
                    break;
                case "getSeed":
                    getSeed(call, result);
                    break;
                case "getPrivateKey":
                    getPrivateKey(call, result);
                    break;
                case "connectToNode":
                    connectToNode(call, result);
                    break;
                case "getTransactions":
                    getTransactions(call, result);
                    break;
                case "countOfTransactions":
                    countOfTransactions(call, result);
                    break;
                case "refresh":
                    refresh(call, result);
                    break;
                case "getFileName":
                    getFileName(call, result);
                    break;
                case "getName":
                    getName(call, result);
                    break;
                case "close":
                    close(call, result);
                    break;
                case "getNodeHeight":
                    getNodeHeight(call, result);
                    break;
                case "isConnected":
                    isConnected(call, result);
                    break;
                case "createTransaction":
                    createTransaction(call, result);
                    break;
                case "commitTransaction":
                    commitTransaction(call, result);
                    break;
            default:
                result.notImplemented();
            }
        } catch (Exception e) {
            result.error("UNCAUGHT_ERROR", e.getMessage(), null);
        }
    }

    private void getAddress(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            Address currentAddress = currentWallet.currentReceiveAddress();
            mainHandler.post(() -> result.success(currentAddress.toString()));
        });
    }

    private void getUnlockedBalance(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            Coin availableBalance = currentWallet.getBalance();
            mainHandler.post(() -> result.success(availableBalance.getValue()));
        });
    }

    private void getFullBalance(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            Coin fullBalance = currentWallet.getBalance(Wallet.BalanceType.ESTIMATED);
            mainHandler.post(() -> result.success(fullBalance.getValue()));
        });
    }

    private void getSeed(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            DeterministicSeed seed = currentWallet.getKeyChainSeed();
            mainHandler.post(() -> result.success(seed.getMnemonicCode()));
        });
    }

    private void getPrivateKey(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            NetworkParameters params = MainNetParams.get();

            DeterministicKey restoreKey = currentWallet.getWatchingKey();
            mainHandler.post(() -> result.success(restoreKey.serializePrivB58(params)));
        });
    }

    private void getNodeHeight(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            try {
                mainHandler.post(() -> result.success(chain.getBestChainHeight()));
            } catch (Exception e) {
                mainHandler.post(() -> result.error("GET_NODE_HEIGHT", e.getMessage(), null));
            }
        });
    }

    private void downloadBlockChain(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            try {
                shutDownWallet(true);

                String host = "94.75.124.54"; // FIXME get host from call
                int port = 8333;

                NetworkParameters params = MainNetParams.get();

                File chainFile = new File(path + ".spvchain");
                blockStore = new SPVBlockStore(params, chainFile);
                chain = new BlockChain(params, blockStore);

                //InetAddress inetAddress = InetAddress.getByName(host);
                //PeerAddress peerAddress = new PeerAddress(params, inetAddress, port);

                peerGroup = new PeerGroup(params, chain);
                peerGroup.setFastCatchupTimeSecs(currentWallet.getEarliestKeyCreationTime());

                if (!host.equals("localhost")) {
                    peerGroup.addPeerDiscovery(new DnsDiscovery(params));
                } else {
                    PeerAddress addr = new PeerAddress(params, InetAddress.getLocalHost());
                    peerGroup.addAddress(addr);
                }

                chain.addWallet(currentWallet);
                peerGroup.addWallet(currentWallet);

                tracker = new DownloadProgressTracker() {
                    @Override
                    protected void startDownload(int blocks) {
                        ByteBuffer buffer = ByteBuffer.allocateDirect(4);
                        buffer.putInt(SYNCING_START);

                        mainHandler.post(() -> progressChannel.send(buffer));
                    }

                    @Override
                    protected void progress(double pct, int blocksSoFar, Date date) {
                        ByteBuffer buffer = ByteBuffer.allocateDirect(12);
                        buffer.putInt(SYNCING_IN_PROGRESS);
                        buffer.putInt((int) pct);
                        buffer.putInt(blocksSoFar);

                        mainHandler.post(() -> progressChannel.send(buffer));
                    }

                    @Override
                    protected void doneDownload() {
                        ByteBuffer buffer = ByteBuffer.allocateDirect(4);
                        buffer.putInt(SYNCING_FINISHED);

                        isConnected = true;

                        mainHandler.post(() -> progressChannel.send(buffer));
                    }
                };

                peerGroup.start();
                peerGroup.startBlockChainDownload(tracker);

                mainHandler.post(() -> result.success(null));
            } catch (Exception e) {
                mainHandler.post(() -> result.error("CONNECTION_ERROR", e.getMessage(), null));
            }
        });
    }

    private void connectToNode(MethodCall call, MethodChannel.Result result) {
        downloadBlockChain(call, result);
    }

    private void getTransactions(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            List<Transaction> transactionList = currentWallet.getTransactionsByTime();
            ArrayList<Map<String, String>> transactionInfo = new ArrayList<>();

            for (Transaction elem : transactionList) {
                HashMap<String, String> hashMap = new HashMap<>();
                hashMap.put("hash", elem.getTxId().toString());

                int height = elem.getConfidence().getConfidenceType() == TransactionConfidence.ConfidenceType.BUILDING
                        ? elem.getConfidence().getAppearedAtChainHeight()
                        : 0;
                hashMap.put("height", String.valueOf(height));

                Coin difference = elem.getValue(currentWallet);
                int direction;
                long amount;

                if (difference.isPositive()) {
                    direction = 0;
                    amount = difference.value;
                } else {
                    direction = 1;
                    amount = -difference.value;
                }

                hashMap.put("direction", String.valueOf(direction));

                long timestamp = elem.getUpdateTime().getTime();
                hashMap.put("timestamp", String.valueOf(timestamp));

                boolean isPending = elem.isPending();
                hashMap.put("isPending", String.valueOf(isPending));

                hashMap.put("amount", String.valueOf(amount));
                hashMap.put("accountIndex", "");

                transactionInfo.add(hashMap);
            }

            if (transactionInfo.size() > 0) {
                mainHandler.post(() -> result.success(transactionInfo));
            } else {
                mainHandler.post(() -> result.success(null));
            }
        });
    }

    private void countOfTransactions(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            List<Transaction> transactionList = currentWallet.getTransactionsByTime();
            mainHandler.post(() -> result.success(transactionList.size()));
        });
    }

    private void refresh(MethodCall call, MethodChannel.Result result) {
        /*String height = call.argument("height");
        int blockHeight;

        try {
            blockHeight = Integer.parseInt(height);
        } catch (Exception e) {
            blockHeight = 0;
        }

        if (blockHeight > chain.getBestChainHeight()) {
            currentWallet.setLastBlockSeenHeight(blockHeight);
        }*/

        downloadBlockChain(call, result);
    }

    private void getFileName(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            File file = new File(path);
            mainHandler.post(() -> result.success(file.getPath()));
        });
    }

    private void getName(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            File file = new File(path);
            mainHandler.post(() -> result.success(file.getName()));
        });
    }

    private void close(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            try {
                shutDownWallet(false);
                mainHandler.post(() -> result.success(null));
            } catch (Exception e) {
                mainHandler.post(() -> result.error("IO_ERROR", e.getMessage(), null));
            }
        });
    }

    private void isConnected(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            mainHandler.post(() -> result.success(isConnected));
        });
    }

    private void createTransaction(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            try {
                NetworkParameters params = MainNetParams.get();

                String value = call.argument("amount");
                LegacyAddress address = LegacyAddress.fromBase58(params, call.argument("address"));

                Coin amount;

                if (value.equals("ALL")) {
                    request = SendRequest.emptyWallet(address);
                } else {
                    amount = Coin.parseCoin(value);
                    request = SendRequest.to(address, amount);
                }

                request.feePerKb = Transaction.REFERENCE_DEFAULT_MIN_TX_FEE;
                currentWallet.completeTx(request);

                Transaction tx = request.tx;
                HashMap<String, String> hashMap = new HashMap<>();
                long fee = tx.getFee().value;

                hashMap.put("amount", String.valueOf(Math.abs(tx.getValue(currentWallet).value) - fee));
                hashMap.put("fee", String.valueOf(fee));
                hashMap.put("hash", tx.getTxId().toString());

                mainHandler.post(() -> result.success(hashMap));
            } catch (Exception e) {
                mainHandler.post(() -> result.error("CREATE_TX_ERROR", e.getMessage(), null));
            }
        });
    }

    private void commitTransaction(MethodCall call, MethodChannel.Result result) {
        AsyncTask.execute(() -> {
            try {
                currentWallet.commitTx(request.tx);

                saveWalletToFile();

                Futures.addCallback(peerGroup.broadcastTransaction(request.tx).future(), new FutureCallback<Transaction>() {
                    @Override
                    public void onSuccess(@NullableDecl Transaction tx) {
                        mainHandler.post(() -> result.success(null));
                    }

                    @Override
                    public void onFailure(Throwable t) {
                        mainHandler.post(() -> result.error("COMMIT_TX_ERROR", t.getMessage(), null));
                    }
                }, MoreExecutors.directExecutor());
            } catch (Exception e) {
                mainHandler.post(() -> result.error("COMMIT_TX_ERROR", e.getMessage(), null));
            }
        });
    }
}
