package com.cakewallet.wallet.handlers.moneroWalletManager.tasks;

import android.content.Context;

import com.cakewallet.wallet.MoneroWalletHandler;
import com.cakewallet.wallet.handlers.moneroWalletManager.credentials.OpenMoneroWalletCredentails;
import com.cakewallet.wallet.monero.Wallet;
import com.cakewallet.wallet.monero.WalletManager;

import io.flutter.plugin.common.MethodChannel;

public class OpenMoneroWalletAsyncTask extends MoneroWalletMangerAsyncTask<OpenMoneroWalletCredentails> {
    public OpenMoneroWalletAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context, MoneroWalletHandler walletHandler) {
        super(walletManager, result, context, walletHandler);
    }

    @Override
    protected Long doInBackground(OpenMoneroWalletCredentails... credentails) {
        long id = walletManager.openWallet(context, credentails[0].name, credentails[0].password);
        walletHandler.setCurrentWallet(new Wallet(id));
        return id;
    }
}