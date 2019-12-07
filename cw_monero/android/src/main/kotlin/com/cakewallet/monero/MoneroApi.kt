package com.cakewallet.monero

class MoneroApi {
    external fun setNodeAddressJNI(uri: String, login: String, password: String, use_ssl: Boolean, is_light_wallet: Boolean)
    external fun connectToNodeJNI()

    companion object {
        init {
            System.loadLibrary("cw_monero")
        }
    }
}