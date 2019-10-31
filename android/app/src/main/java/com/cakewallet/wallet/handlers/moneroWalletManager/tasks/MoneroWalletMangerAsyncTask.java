package com.cakewallet.wallet.handlers.moneroWalletManager.tasks;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;

import com.cakewallet.wallet.utils.Credentials;
import com.cakewallet.wallet.MoneroWalletHandler;
import com.cakewallet.wallet.monero.WalletManager;

import io.flutter.plugin.common.MethodChannel;

public abstract class MoneroWalletMangerAsyncTask<Creds extends Credentials> extends AsyncTask<Creds, Void, Long> {
    protected WalletManager walletManager;
    protected MethodChannel.Result result;
    protected Context context;
    protected MoneroWalletHandler walletHandler;

    MoneroWalletMangerAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context, MoneroWalletHandler walletHandler) {
        this.walletManager = walletManager;
        this.result = result;
        this.context = context;
        this.walletHandler = walletHandler;
    }

    protected void onPostExecute(Long id) {
        new Handler(Looper.getMainLooper())
                .post(() -> result.success(id));
    }
}