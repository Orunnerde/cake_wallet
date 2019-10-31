package com.cakewallet.wallet.monero;

import java.util.Arrays;
import java.util.List;

public class Subaddress {
    long id;

    public Subaddress(long id) {
        this.id = id;
    }

    public List<SubaddressRow> getAll() {
        return Arrays.asList(getAllJNI());
    }

    public void refresh(int accountIndex) {
        refreshJNI(accountIndex);
    }

    public void add(int accountIndex, String label) {
        addRowJNI(accountIndex, label);
    }

    public void setLabel(int accountIndex, int addressIndex, String label) {
        setLabelJNI(accountIndex, addressIndex, label);
    }

    private native SubaddressRow[] getAllJNI();

    private native void refreshJNI(int accountIndex);

    private native void addRowJNI(int accountIndex, String label);

    private native void setLabelJNI(int accountIndex, int addressIndex, String label);
}
