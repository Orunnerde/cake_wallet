package com.cakewallet.wallet.handlers.moneroWalletManager.tasks;

import android.content.Context;

import com.cakewallet.wallet.MoneroWalletHandler;
import com.cakewallet.wallet.handlers.moneroWalletManager.credentials.RestoreMoneroWalletFromKeysCredentails;
import com.cakewallet.wallet.monero.Wallet;
import com.cakewallet.wallet.monero.WalletManager;

import io.flutter.plugin.common.MethodChannel;

public class RestoreMoneroWalletFromKeysAsyncTask extends MoneroWalletMangerAsyncTask<RestoreMoneroWalletFromKeysCredentails> {
    public RestoreMoneroWalletFromKeysAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context, MoneroWalletHandler walletHandler) {
        super(walletManager, result, context, walletHandler);
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
        walletHandler.setCurrentWallet(new Wallet(id));
        return id;
    }
}