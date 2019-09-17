package com.cakewallet.wallet.handlers.moneroWalletManager.credentials;

import com.cakewallet.wallet.utils.Credentials;

public class CreateMoneroWalletCredentails extends Credentials {
    public String name;
    public String password;


    public CreateMoneroWalletCredentails(String name, String password) {
        this.name = name;
        this.password = password;
    }
}
