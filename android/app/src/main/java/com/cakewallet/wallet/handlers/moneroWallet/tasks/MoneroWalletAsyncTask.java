package com.cakewallet.wallet.handlers.moneroWallet.tasks;

import android.os.AsyncTask;

import com.cakewallet.wallet.utils.Credentials;
import com.cakewallet.wallet.monero.Wallet;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public abstract class MoneroWalletAsyncTask<Creds extends MethodCall> extends AsyncTask<Creds, Void, Long> {
    protected MethodChannel.Result result;

    protected Wallet moneroWallet;

    public MoneroWalletAsyncTask(MethodChannel.Result result) {
        this.result = result;
    }

    protected void onPostExecute(Long id) {
        result.success(id);
    }
}

//public class GetHeightMoneroWallet<Creds extends MethodCall> extends MoneroWalletAsyncTask<Creds, Void, Long> {
//
//    public GetHeightMoneroWallet(MethodChannel.Result result) {
//        super(result);
//    }
//
//    @Override
//    protected Long doInBackground(Creds ... creds) {
//        return Long.valueOf(1);
//    }
//}