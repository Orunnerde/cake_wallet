package com.cakewallet.wallet.handlers.moneroWalletManager.tasks;

import android.content.Context;

import com.cakewallet.wallet.handlers.moneroWalletManager.credentials.CreateMoneroWalletCredentails;
import com.cakewallet.wallet.MoneroWalletHandler;
import com.cakewallet.wallet.monero.Wallet;
import com.cakewallet.wallet.monero.WalletManager;

import io.flutter.plugin.common.MethodChannel;

public class CreateMoneroWalletAsyncTask extends MoneroWalletMangerAsyncTask<CreateMoneroWalletCredentails> {
    public CreateMoneroWalletAsyncTask(WalletManager walletManager, MethodChannel.Result result, Context context, MoneroWalletHandler walletHandler) {
        super(walletManager, result, context, walletHandler);
    }

    @Override
    protected Long doInBackground(CreateMoneroWalletCredentails... credentails) {
        long id = walletManager.createWallet(context, credentails[0].name, credentails[0].password);
        walletHandler.setCurrentWallet(new Wallet(id));
        return id;
    }
}