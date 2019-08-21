package com.cakewallet.wallet;

import android.content.Context;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import com.cakewallet.wallet.monero.WalletManager;
import com.cakewallet.wallet.monero.Wallet;
import com.cakewallet.wallet.MoneroWalletHandler;

class MoneroWalletsManagerHandler {
    private static final WalletManager MoneroWalletsManager = new WalletManager();

    public void handle(MethodCall call, MethodChannel.Result result, Context context) {
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
    }

    public void createWallet(MethodCall call, MethodChannel.Result result, Context context) {
        String name = (String) call.argument("name");
        String password = (String) call.argument("password");
        long id = MoneroWalletsManager.createWallet(context, name, password);
        MoneroWalletHandler.setCurrentWallet(new Wallet(id));
        result.success(id);
    }

    public void openWallet(MethodCall call, MethodChannel.Result result, Context context) {
        String name = (String) call.argument("name");
        String password = (String) call.argument("password");
        long id = MoneroWalletsManager.openWallet(context, name, password);
        MoneroWalletHandler.setCurrentWallet(new Wallet(id));
        result.success(id);
    }

    public void recoveryWalletFromSeed(MethodCall call, MethodChannel.Result result, Context context) {
        String name = (String) call.argument("name");
        String password = (String) call.argument("password");
        String seed = (String) call.argument("seed");
        long height = (long) call.argument("restoreHeight");
        long id = MoneroWalletsManager.recoveryWalletFromSeed(context, name, password, seed, height);
        MoneroWalletHandler.setCurrentWallet(new Wallet(id));
        result.success(id);
    }

    public void recoveryWalletFromKeys(MethodCall call, MethodChannel.Result result, Context context) {
        String name = (String) call.argument("name");
        String password = (String) call.argument("password");
        String address = (String) call.argument("address");
        String viewKey = (String) call.argument("viewKey");
        String spendKey = (String) call.argument("spendKey");
        long height = (long) call.argument("restoreHeight");
        long id = MoneroWalletsManager.recoveryWalletFromKeys(context, name, password, height, address, viewKey, spendKey);
        MoneroWalletHandler.setCurrentWallet(new Wallet(id));
        result.success(id);
    }

    public void isExist(MethodCall call, MethodChannel.Result result, Context context) {
        String name = (String) call.argument("name");
        boolean isExist = MoneroWalletsManager.isExist(context, name);
        result.success(isExist);
    }
}
