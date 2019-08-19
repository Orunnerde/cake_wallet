package com.cakewallet.wallet;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import com.cakewallet.wallet.monero.Wallet;

public class MoneroWalletHandler {
    private static Wallet currentWallet;

    public static Wallet getCurrentWallet() {
        return currentWallet;
    };

    public static void setCurrentWallet(Wallet wallet) {
        currentWallet = wallet;
    }

    public void handle(MethodCall call, MethodChannel.Result result) {
        if (getCurrentWallet() == null) {
            result.error("NO_WALLET", "Current wallet not set for monero", null);
            return;
        }

        switch (call.method) {
            case "getFilename":
                getFilename(call, result);
                break;
            case "getSeed":
                getSeed(call, result);
                break;
            case "getAddress":
                getAddress(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
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
}