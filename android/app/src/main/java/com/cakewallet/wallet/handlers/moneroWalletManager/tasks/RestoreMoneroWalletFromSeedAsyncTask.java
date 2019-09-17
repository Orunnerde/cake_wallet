package com.cakewallet.wallet.handlers.moneroWalletManager.tasks;

import android.content.Context;

import com.cakewallet.wallet.MoneroWalletHandler;
import com.cakewallet.wallet.handlers.moneroWalletManager.credentials.RestoreMoneroWalletFromSeedCredentails;
import com.cakewallet.wallet.monero.Wallet;
import com.cakewallet.wallet.monero.WalletManager;

import io.flutter.plugin.common.MethodChannel;

public class RestoreMoneroWalletFromSeedAsyncTask extends MoneroWalletMangerAsyncTask<RestoreMoneroWalletFromSeedCredentails> {
    public RestoreMoneroWalletFromSeedAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context, MoneroWalletHandler walletHandler) {
        super(walletManager, result, context, walletHandler);
    }

    @Override
    protected Long doInBackground(RestoreMoneroWalletFromSeedCredentails... credentails) {
        long id = walletManager.recoveryWalletFromSeed(
                context,
                credentails[0].name,
                credentails[0].password,
                credentails[0].seed,
                credentails[0].height);
        walletHandler.setCurrentWallet(new Wallet(id));
        return id;
    }
}