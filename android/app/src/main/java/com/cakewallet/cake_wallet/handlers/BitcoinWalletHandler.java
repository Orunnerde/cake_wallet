package com.cakewallet.cake_wallet.handlers;

import org.bitcoinj.core.Address;
import org.bitcoinj.core.Base58;
import org.bitcoinj.core.Coin;
import org.bitcoinj.core.DumpedPrivateKey;
import org.bitcoinj.core.ECKey;
import org.bitcoinj.core.NetworkParameters;
import org.bitcoinj.crypto.DeterministicKey;
import org.bitcoinj.params.MainNetParams;
import org.bitcoinj.script.Script;
import org.bitcoinj.wallet.DeterministicSeed;
import org.bitcoinj.wallet.Wallet;

import java.io.File;
import java.math.BigInteger;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BitcoinWalletHandler {
    public static final String BITCOIN_WALLET_CHANNEL = "com.cakewallet.cake_wallet/bitcoin-wallet";
    private Wallet currentWallet;

    public boolean createWallet(String path, String password) throws Exception {
        NetworkParameters params = MainNetParams.get();
        ECKey key = new ECKey();
        File file = new File(path);

        currentWallet = Wallet.createDeterministic(params, Script.ScriptType.P2PKH);
        currentWallet.importKey(key);
        currentWallet.encrypt(password);
        currentWallet.saveToFile(file);
        return true;
    }

    public boolean openWallet(String path, String password) throws Exception {
        File file = new File(path);

        currentWallet = Wallet.loadFromFile(file);
        currentWallet.decrypt(password);
        return true;
    }

    public boolean restoreWalletFromSeed(String path, String password, List<String> seed, String passphrase) throws Exception {
        NetworkParameters params = MainNetParams.get();
        File file = new File(path);
        long creationTime = 1409478661L;

        DeterministicSeed deterministicSeed = new DeterministicSeed(seed, null, passphrase, creationTime);
        currentWallet = Wallet.fromSeed(params, deterministicSeed, Script.ScriptType.P2PKH);
        currentWallet.encrypt(password);
        currentWallet.saveToFile(file);
        return true;
    }

    public boolean restoreWalletFromKey(String path, String password, String privateKey) throws Exception {
        NetworkParameters params = MainNetParams.get();
        File file = new File(path);

        ECKey key;
        if (privateKey.length() == 51 || privateKey.length() == 52) {
            DumpedPrivateKey dumpedPrivateKey = DumpedPrivateKey.fromBase58(params, privateKey);
            key = dumpedPrivateKey.getKey();
        } else {
            BigInteger privKey = Base58.decodeToBigInteger(privateKey);
            key = ECKey.fromPrivate(privKey);
        }

        currentWallet = Wallet.createDeterministic(params, Script.ScriptType.P2PKH);
        currentWallet.importKey(key);
        currentWallet.encrypt(password);
        currentWallet.saveToFile(file);
        return true;
    }

    public void handle(MethodCall call, MethodChannel.Result result) {
        try {
            switch (call.method) {
                case "getAddress":
                    getAddress(call, result);
                    break;
                case "getBalance":
                    getBalance(call, result);
                    break;
                case "getSeed":
                    getSeed(call, result);
                    break;
                case "getPrivateKey":
                    getPrivateKey(call, result);
                    break;
                default:
                    result.notImplemented();
            }
        } catch (Exception e){
            result.error("UNCAUGHT_ERROR", e.getMessage(), null);
        }
    }

    private void getAddress(MethodCall call, MethodChannel.Result result) {
        Address currentAddress = currentWallet.currentReceiveAddress();
        result.success(currentAddress.toString());
    }

    private void getBalance(MethodCall call, MethodChannel.Result result) {
        Coin availableBalance = currentWallet.getBalance();
        result.success(availableBalance.value);
    }

    private void getSeed(MethodCall call, MethodChannel.Result result) {
        DeterministicSeed seed = currentWallet.getKeyChainSeed();
        result.success(seed.getMnemonicCode());
    }

    private void getPrivateKey(MethodCall call, MethodChannel.Result result) {
        DeterministicKey key = currentWallet.currentReceiveKey();
        result.success(key.getPrivKey().toString());
    }
}