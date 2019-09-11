package com.cakewallet.wallet;

import android.content.Context;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryCodec;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.cakewallet.wallet.MoneroWalletsManagerHandler;
import com.cakewallet.wallet.MoneroWalletHandler;
import com.cakewallet.wallet.monero.Wallet;

import java.nio.ByteBuffer;

public class MainActivity extends FlutterActivity {
    private static final MoneroWalletsManagerHandler moneroWalletsManagerHandler = new MoneroWalletsManagerHandler();
    private static final MoneroWalletHandler moneroWalletHandler = new MoneroWalletHandler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        MethodChannel walletManagerChannel = new MethodChannel(getFlutterView(), MoneroWalletsManagerHandler.MONERO_WALLET_MANAGER_CHANNEL);
        walletManagerChannel.setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        moneroWalletsManagerHandler.handle(call, result, getApplicationContext());
                    }
                });

        MethodChannel walletChannel = new MethodChannel(getFlutterView(), MoneroWalletHandler.MONERO_WALLET_CHANNEL);

        BasicMessageChannel<String> balanceChannel = new BasicMessageChannel<>(getFlutterView(), "balance_change", StringCodec.INSTANCE);
        BasicMessageChannel<ByteBuffer> syncStateChannel = new BasicMessageChannel<>(getFlutterView(), "sync_state", BinaryCodec.INSTANCE);
        BasicMessageChannel<ByteBuffer> walletHeightChannel = new BasicMessageChannel<>(getFlutterView(), "wallet_height", BinaryCodec.INSTANCE);


        moneroWalletHandler.setBalanceChannel(balanceChannel);
        moneroWalletHandler.setSyncStateChannel(syncStateChannel);
        moneroWalletHandler.setWalletHeightChannel(walletHeightChannel);

        Wallet.setListener(moneroWalletHandler);

        walletChannel.setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {
                        moneroWalletHandler.handle(call, result);
                    }
                });
    }


}
