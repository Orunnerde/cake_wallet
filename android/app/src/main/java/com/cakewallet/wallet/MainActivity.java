package com.cakewallet.wallet;

import android.content.Context;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import com.cakewallet.wallet.MoneroWalletManagerHandler;
import com.cakewallet.wallet.MoneroWalletHandler;

public class MainActivity extends FlutterActivity {
  private static final String MONERO_WALLET_MANAGER_CHANNEL = "com.cakewallet.wallet/monero-wallet-manager";
    private static final String MONERO_WALLET_CHANNEL = "com.cakewallet.wallet/monero-wallet";
    private static final MoneroWalletManagerHandler moneroWalletManagerHandler = new MoneroWalletManagerHandler();
    private static final MoneroWalletHandler moneroWalletHandler = new MoneroWalletHandler();

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), MONERO_WALLET_MANAGER_CHANNEL).setMethodCallHandler(

            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                  moneroWalletManagerHandler.handle(call, result, getApplicationContext());
              }
            });

      new MethodChannel(getFlutterView(), MONERO_WALLET_CHANNEL).setMethodCallHandler(

              new MethodCallHandler() {
                  @Override
                  public void onMethodCall(MethodCall call, Result result) {
                      moneroWalletHandler.handle(call, result);
                  }
              });
  }


}
