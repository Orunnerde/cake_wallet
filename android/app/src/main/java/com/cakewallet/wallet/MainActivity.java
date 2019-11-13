package com.cakewallet.wallet;

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
import android.view.WindowManager.LayoutParams;

import com.cakewallet.wallet.handlers.moneroWalletManager.MoneroWalletManagerHandler;
import com.cakewallet.wallet.monero.Wallet;

import java.nio.ByteBuffer;

public class MainActivity extends FlutterActivity {
    private static final MoneroWalletHandler moneroWalletHandler = new MoneroWalletHandler();
    private static final MoneroWalletManagerHandler moneroWalletsManagerHandler = new MoneroWalletManagerHandler(moneroWalletHandler);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getWindow().addFlags(LayoutParams.FLAG_SECURE);

        GeneratedPluginRegistrant.registerWith(this);


        MethodChannel walletManagerChannel = new MethodChannel(getFlutterView(), MoneroWalletManagerHandler.MONERO_WALLET_MANAGER_CHANNEL);
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
