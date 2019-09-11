package com.cakewallet.wallet;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import com.cakewallet.wallet.monero.WalletManager;
import com.cakewallet.wallet.monero.Wallet;

class OpenMoneroWalletCredentails extends Credentials {
    String name;
    String password;


    OpenMoneroWalletCredentails(String name, String password) {
        this.name = name;
        this.password = password;
    }
}

class CreateMoneroWalletCredentails extends Credentials {
    String name;
    String password;


    CreateMoneroWalletCredentails(String name, String password) {
        this.name = name;
        this.password = password;
    }
}

class RestoreMoneroWalletFromSeedCredentails extends Credentials {
    String name;
    String password;
    String seed;
    long height;


    RestoreMoneroWalletFromSeedCredentails(String name, String password, String seed, long height) {
        this.name = name;
        this.password = password;
        this.seed = seed;
        this.height = height;
    }
}

class RestoreMoneroWalletFromKeysCredentails extends Credentials {
    String name;
    String password;
    String address;
    String viewKey;
    String spenKey;
    long height;


    RestoreMoneroWalletFromKeysCredentails(String name, String password, String address, String viewKey, String spenKey, long height) {
        this.name = name;
        this.password = password;
        this.viewKey = viewKey;
        this.spenKey = spenKey;
        this.address = address;
        this.height = height;
    }
}

abstract class Credentials {}

abstract class MoneroWalletMangerAsyncTask<Creds extends Credentials> extends AsyncTask<Creds, Void, Long> {
    WalletManager walletManager;
    MethodChannel.Result result;
    Context context;

    MoneroWalletMangerAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context) {
        this.walletManager = walletManager;
        this.result = result;
        this.context = context;
    }

    protected void onPostExecute(Long id) {
        result.success(id);
    }
}

class OpenMoneroWalletAsyncTask extends MoneroWalletMangerAsyncTask<OpenMoneroWalletCredentails> {
    OpenMoneroWalletAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context) {
        super(walletManager, result, context);
    }

    @Override
    protected Long doInBackground(OpenMoneroWalletCredentails... credentails) {
        long id = walletManager.openWallet(context, credentails[0].name, credentails[0].password);
        MoneroWalletHandler.setCurrentWallet(new Wallet(id));
        return id;
    }
}

class CreateMoneroWalletAsyncTask extends MoneroWalletMangerAsyncTask<CreateMoneroWalletCredentails> {
    CreateMoneroWalletAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context) {
        super(walletManager, result, context);
    }

    @Override
    protected Long doInBackground(CreateMoneroWalletCredentails... credentails) {
        long id = walletManager.createWallet(context, credentails[0].name, credentails[0].password);
        MoneroWalletHandler.setCurrentWallet(new Wallet(id));
        return id;
    }
}

class RestoreMoneroWalletFromSeedAsyncTask extends MoneroWalletMangerAsyncTask<RestoreMoneroWalletFromSeedCredentails> {
    RestoreMoneroWalletFromSeedAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context) {
        super(walletManager, result, context);
    }

    @Override
    protected Long doInBackground(RestoreMoneroWalletFromSeedCredentails... credentails) {
        long id = walletManager.recoveryWalletFromSeed(
                context,
                credentails[0].name,
                credentails[0].password,
                credentails[0].seed,
                credentails[0].height);
        MoneroWalletHandler.setCurrentWallet(new Wallet(id));
        return id;
    }
}

class RestoreMoneroWalletFromKeysAsyncTask extends MoneroWalletMangerAsyncTask<RestoreMoneroWalletFromKeysCredentails> {
    RestoreMoneroWalletFromKeysAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context) {
        super(walletManager, result, context);
    }

    @Override
    protected Long doInBackground(RestoreMoneroWalletFromKeysCredentails... credentails) {
        long id = walletManager.recoveryWalletFromKeys(
                context,
                credentails[0].name,
                credentails[0].password,
                credentails[0].height,
                credentails[0].address,
                credentails[0].viewKey,
                credentails[0].spenKey);
        MoneroWalletHandler.setCurrentWallet(new Wallet(id));
        return id;
    }
}


class MoneroWalletsManagerHandler {
    static final String MONERO_WALLET_MANAGER_CHANNEL = "com.cakewallet.wallet/monero-wallet-manager";

    private static final WalletManager MoneroWalletsManager = new WalletManager();

    void handle(MethodCall call, MethodChannel.Result result, Context context) {
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
                context);
        CreateMoneroWalletCredentails credentails = new CreateMoneroWalletCredentails(name, password);
        createMoneroWalletAsyncTask.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, credentails);
    }

    private void openWallet(MethodCall call, MethodChannel.Result result, Context context) {
        String name = call.argument("name");
        String password = call.argument("password");
        OpenMoneroWalletAsyncTask openMoneroWalletAsyncTask = new OpenMoneroWalletAsyncTask(
                MoneroWalletsManager,
                result,
                context);
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
        RestoreMoneroWalletFromSeedAsyncTask restoreTask = new RestoreMoneroWalletFromSeedAsyncTask(MoneroWalletsManager, result, context);
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
        RestoreMoneroWalletFromKeysAsyncTask restoreTask = new RestoreMoneroWalletFromKeysAsyncTask(MoneroWalletsManager, result, context);
        restoreTask.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR, credentails);
    }

    private void isExist(MethodCall call, MethodChannel.Result result, Context context) {
        AsyncTask.execute(() -> {
            String name = call.argument("name");
            boolean isExist = MoneroWalletsManager.isExist(context, name);

            Handler mainHandler = new Handler(Looper.getMainLooper());
            mainHandler.post(() -> result.success(isExist));
        });
    }
}
