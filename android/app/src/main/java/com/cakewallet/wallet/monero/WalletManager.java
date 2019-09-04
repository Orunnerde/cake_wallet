package com.cakewallet.wallet.monero;
import java.io.File;
import android.content.Context;

public class WalletManager {
    static final String DEFAULT_LANGUAGE = "English";
    static final int DEFAULT_NETWORK_TYPE = 0;
    static final String WALLET_DIR = "cw_monero";

    public static File getStorage(Context context, String dirName) {
        File dir = new File(context.getFilesDir(), dirName);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        if (!dir.isDirectory()) {
            String msg = "Directory " + dir.getAbsolutePath() + " does not exist.";
            throw new IllegalStateException(msg);
        }
        return dir;
    }

    public static File getDirForWallet(Context context, String name) {
        File walletsRoot = getWalletRoot(context);
//        File walletDir = new File(walletsRoot.getAbsolutePath() + "/" + name);
//
//        if (!walletDir.exists()) {
//            walletDir.mkdirs();
//        }

        File walletRoot = new File(walletsRoot, name);
        return walletRoot;
    }

    static public File getWalletRoot(Context context) {
        return getStorage(context, WALLET_DIR);
    }

    static {
        System.loadLibrary("cwmonero_lib");
    }

    public long createWallet(Context context, String name, String password) {
        File walletsRoot = getWalletRoot(context);
        File walletRoot = new File(walletsRoot, name);
        return createWallet(walletRoot, password);
    }

    public long createWallet(File file, String password) {
        return createWallet(file, password, DEFAULT_LANGUAGE, DEFAULT_NETWORK_TYPE);
    }

    public long createWallet(File file, String password, String language, int networkType) {
        return createWalletJNI(file.getAbsolutePath(), password, language, networkType);
    }

    public long recoveryWalletFromSeed(Context context, String name, String password, String seed, long restoreHeight) {
        return recoveryWalletFromSeed(context, name, password, seed, DEFAULT_NETWORK_TYPE, restoreHeight);
    }

    public long recoveryWalletFromSeed(Context context, String name, String password, String seed, int networkType, long restoreHeight) {
        File walletsRoot = getWalletRoot(context);
        File walletRoot = new File(walletsRoot, name);
        return recoveryWalletFromSeed(walletRoot, password, seed, networkType, restoreHeight);
    }

    public long recoveryWalletFromSeed(File file, String password, String seed, int networkType, long restoreHeight) {
        return recoveryWalletFromSeedJNI(file.getAbsolutePath(), password, seed, networkType, restoreHeight);
    }

    public long recoveryWalletFromKeys(
            Context context,
            String name,
            String password,
            long restoreHeight,
            String address,
            String viewKey,
            String spendKey) {
        return recoveryWalletFromKeys(
                context,
                name,
                password,
                WalletManager.DEFAULT_LANGUAGE,
                WalletManager.DEFAULT_NETWORK_TYPE,
                restoreHeight, address,
                viewKey, spendKey);
    }

    public long recoveryWalletFromKeys(
            Context context,
            String name,
            String password,
            String language,
            int networkType,
            long restoreHeight,
            String address,
            String viewKey,
            String spendKey) {
        File walletsRoot = getWalletRoot(context);
        File walletRoot = new File(walletsRoot, name);
        return recoveryWalletFromKeys(
                walletRoot,
                password,
                language,
                networkType,
                restoreHeight,
                address,
                viewKey,
                spendKey);
    }

    public long recoveryWalletFromKeys(
            File file,
            String password,
            String language,
            int networkType,
            long restoreHeight,
            String address,
            String viewKey,
            String spendKey) {
        return createWalletFromKeysJNI(
                file.getAbsolutePath(),
                password, language,
                networkType, restoreHeight,
                address,
                viewKey, spendKey);
    }

    public long openWallet(Context context, String name, String password) {
        File path = getDirForWallet(context, name);
        return openWallet(path, password);
    }

    public long openWallet(File file, String password) {
        return openWallet(file, password, DEFAULT_NETWORK_TYPE);
    }

    public long openWallet(File file, String password, int networkType) {
        return openWalletJNI(file.getAbsolutePath(), password, networkType);
    }

    public boolean close(Wallet wallet, boolean store) {
        return closeJNI(wallet.id, store);
    }

    public boolean isExist(Context context, String name) {
        File path = getDirForWallet(context, name);
        return isExist(path);
    }

    public boolean isExist(File file) {
        return isExistJNI(file.getAbsolutePath());
    }

    private native long openWalletJNI(String path, String password, int networkType);
    private native long createWalletJNI(String path, String password, String language, int networkType);
    private native long recoveryWalletFromSeedJNI(String path, String password, String seed, int networkType, long restoreHeight);
    private native long createWalletFromKeysJNI(String path, String password, String language, int networkType, long restoreHeight, String addressString, String viewKeyString, String spendKeyString);
    private native boolean closeJNI(long walletID, boolean store);
    private native boolean isExistJNI(String path);
}