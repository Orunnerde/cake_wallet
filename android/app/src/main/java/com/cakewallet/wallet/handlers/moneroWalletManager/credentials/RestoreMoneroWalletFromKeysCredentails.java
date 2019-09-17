package com.cakewallet.wallet.handlers.moneroWalletManager.credentials;

import com.cakewallet.wallet.utils.Credentials;

public class RestoreMoneroWalletFromKeysCredentails extends Credentials {
    public String name;
    public String password;
    public String address;
    public String viewKey;
    public String spenKey;
    public long height;


    public RestoreMoneroWalletFromKeysCredentails(String name, String password, String address, String viewKey, String spenKey, long height) {
        this.name = name;
        this.password = password;
        this.viewKey = viewKey;
        this.spenKey = spenKey;
        this.address = address;
        this.height = height;
    }
}