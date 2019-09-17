package com.cakewallet.wallet.handlers.moneroWalletManager.credentials;

import com.cakewallet.wallet.utils.Credentials;

public class RestoreMoneroWalletFromSeedCredentails extends Credentials {
    public String name;
    public String password;
    public String seed;
    public long height;


    public RestoreMoneroWalletFromSeedCredentails(String name, String password, String seed, long height) {
        this.name = name;
        this.password = password;
        this.seed = seed;
        this.height = height;
    }
}