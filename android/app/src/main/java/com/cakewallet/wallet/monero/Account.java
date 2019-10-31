package com.cakewallet.wallet.monero;

import java.util.Arrays;
import java.util.List;

public class Account {
    long id;

    public Account(long id) {
        this.id = id;
    }

    public List<AccountRow> getAll() {
        return Arrays.asList(getAllJNI());
    }
    
    public void refresh() {
        refreshJNI();
    }

    public void add(String label) {
        addRowJNI(label);
    }

    public void setLabel(int accountIndex, String label) {
        setLabelJNI(accountIndex, label);
    }

    private native AccountRow[] getAllJNI();

    private native void refreshJNI();

    private native void addRowJNI(String label);

    private native void setLabelJNI(int addressIndex, String label);
}
