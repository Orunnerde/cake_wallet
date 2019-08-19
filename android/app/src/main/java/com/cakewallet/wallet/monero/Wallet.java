package com.cakewallet.wallet.monero;

public class Wallet {
    public long id;

    public Wallet(long id) {
        this.id = id;
    }

    public String getSeed() {
        return getSeedJNI();
    }

    public String getFilename() {
        return getFilemameJNI();
    }

    public String getAddress() {
        return getAddress(0, 0);
    }

    public String getAddress(long accountIndex, long addressIndex) {
        return getAddressJNI(accountIndex, addressIndex);
    }

    private native String getSeedJNI();
    private native String getFilemameJNI();
    private native String getAddressJNI(long accountIndex, long addressIndex);
}
