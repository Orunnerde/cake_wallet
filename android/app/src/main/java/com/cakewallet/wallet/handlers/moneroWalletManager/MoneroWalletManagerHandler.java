package com.cakewallet.wallet.handlers.moneroWalletManager;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import com.cakewallet.wallet.MoneroWalletHandler;
import com.cakewallet.wallet.monero.WalletManager;
import com.cakewallet.wallet.handlers.moneroWalletManager.tasks.*;
import com.cakewallet.wallet.handlers.moneroWalletManager.credentials.*;


public class MoneroWalletManagerHandler {
    public static final String MONERO_WALLET_MANAGER_CHANNEL = "com.cakewallet.wallet/monero-wallet-manager";

    private static final WalletManager MoneroWalletsManager = new WalletManager();

    private MoneroWalletHandler moneroWalletHandler;

    public MoneroWalletManagerHandler(MoneroWalletHandler moneroWalletHandler) {
        this.moneroWalletHandler = moneroWalletHandler;
    }

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

    private void createWallet(MethodCall call, MethodChannel.Result result, Context context) {
        String name = call.argument("name");
        String password = call.argument("password");
        CreateMoneroWalletAsyncTask createMoneroWalletAsyncTask = new CreateMoneroWalletAsyncTask(
                MoneroWalletsManager,
                result,
                context,
                moneroWalletHandler);
        CreateMoneroWalletCredentails credentails = new CreateMoneroWalletCredentails(name, password);
        createMoneroWalletAsyncTask.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, credentails);
    }

    private void openWallet(MethodCall call, MethodChannel.Result result, Context context) {
        String name = call.argument("name");
        String password = call.argument("password");
        OpenMoneroWalletAsyncTask openMoneroWalletAsyncTask = new OpenMoneroWalletAsyncTask(
                MoneroWalletsManager,
                result,
                context,
                moneroWalletHandler);
        OpenMoneroWalletCredentails credentails = new OpenMoneroWalletCredentails(name, password);
        openMoneroWalletAsyncTask.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, credentails);
    }

    private void recoveryWalletFromSeed(MethodCall call, MethodChannel.Result result, Context context) {
        String name = call.argument("name");
        String password = call.argument("password");
        String seed = call.argument("seed");
        int _height = call.argument("restoreHeight");
        long height = Long.valueOf(_height);

        RestoreMoneroWalletFromSeedCredentails credentails = new RestoreMoneroWalletFromSeedCredentails(name, password, seed, height);
        RestoreMoneroWalletFromSeedAsyncTask restoreTask = new RestoreMoneroWalletFromSeedAsyncTask(MoneroWalletsManager, result, context, moneroWalletHandler);
        restoreTask.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, credentails);
    }

    private void recoveryWalletFromKeys(MethodCall call, MethodChannel.Result result, Context context) {
        String name = call.argument("name");
        String password = call.argument("password");
        String address = call.argument("address");
        String viewKey = call.argument("viewKey");
        String spendKey = call.argument("spendKey");
        int _height = call.argument("restoreHeight");
        long height = Long.valueOf(_height);

        RestoreMoneroWalletFromKeysCredentails credentails = new RestoreMoneroWalletFromKeysCredentails(name, password, address, viewKey, spendKey, height);
        RestoreMoneroWalletFromKeysAsyncTask restoreTask = new RestoreMoneroWalletFromKeysAsyncTask(MoneroWalletsManager, result, context, moneroWalletHandler);
        restoreTask.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, credentails);
    }

    private void isExist(MethodCall call, MethodChannel.Result result, Context context) {
        AsyncTask.execute(() -> {
            String name = call.argument("name");
            boolean isExist = MoneroWalletsManager.isExist(context, name);

            new Handler(Looper.getMainLooper())
                    .post(() -> result.success(isExist));
        });
    }
}
