package com.cakewallet.wallet;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import com.cakewallet.wallet.monero.WalletManager;
import com.cakewallet.wallet.monero.Wallet;

class MoneroWalletsManagerHandler {
    static final String MONERO_WALLET_MANAGER_CHANNEL = "com.cakewallet.wallet/monero-wallet-manager";

    private static final WalletManager MoneroWalletsManager = new WalletManager();

    public void handle(MethodCall call, MethodChannel.Result result, Context context) {
        try {
            switch (call.method) {
                case "createWallet":
                    createWallet(call, result, context);
                    break;
                case "openWallet":
                    openWallet(call, result, context);
                    break;
                case "recoveryWalletFromSeed":
                    recoveryWalletFromSeed(call, result, context);
                    break;
                case "recoveryWalletFromKeys":
                    recoveryWalletFromKeys(call, result, context);
                    break;
                case "isWalletExist":
                    isExist(call, result, context);
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        } catch (Exception e) {
            result.error("UNCAUGHT_ERROR", e.getMessage(), null);
        }
    }

    public void createWallet(MethodCall call, MethodChannel.Result result, Context context) {
        AsyncTask.execute(() -> {
            String name = call.argument("name");
            String password = call.argument("password");
            long id = MoneroWalletsManager.createWallet(context, name, password);
            MoneroWalletHandler.setCurrentWallet(new Wallet(id));

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(id));
        });
    }

    public void openWallet(MethodCall call, MethodChannel.Result result, Context context) {
        AsyncTask.execute(() -> {
            String name = call.argument("name");
            String password = call.argument("password");
            long id = MoneroWalletsManager.openWallet(context, name, password);
            MoneroWalletHandler.setCurrentWallet(new Wallet(id));

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(id));
        });
    }

    public void recoveryWalletFromSeed(MethodCall call, MethodChannel.Result result, Context context) {
        AsyncTask.execute(() -> {
            String name = call.argument("name");
            String password = call.argument("password");
            String seed = call.argument("seed");
            int _height = call.argument("restoreHeight");
            long height = Long.valueOf(_height);
            long id = MoneroWalletsManager.recoveryWalletFromSeed(context, name, password, seed, height);
            MoneroWalletHandler.setCurrentWallet(new Wallet(id));
            Wallet wallet = MoneroWalletHandler.getCurrentWallet();
            wallet.setRecoveringFromSeed(true);
            wallet.setRefreshFromBlockHeight(height);

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(id));
        });
    }

    public void recoveryWalletFromKeys(MethodCall call, MethodChannel.Result result, Context context) {
        AsyncTask.execute(() -> {
            String name = call.argument("name");
            String password = call.argument("password");
            String address = call.argument("address");
            String viewKey = call.argument("viewKey");
            String spendKey = call.argument("spendKey");
            int _height = call.argument("restoreHeight");
            long height = Long.valueOf(_height);
            long id = MoneroWalletsManager.recoveryWalletFromKeys(context, name, password, height, address, viewKey, spendKey);
            MoneroWalletHandler.setCurrentWallet(new Wallet(id));
            Wallet wallet = MoneroWalletHandler.getCurrentWallet();
            wallet.setRecoveringFromSeed(true);
            wallet.setRefreshFromBlockHeight(height);

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(id));
        });
    }

    public void isExist(MethodCall call, MethodChannel.Result result, Context context) {
        AsyncTask.execute(() -> {
            String name = call.argument("name");
            boolean isExist = MoneroWalletsManager.isExist(context, name);

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(isExist));
        });
    }
}
