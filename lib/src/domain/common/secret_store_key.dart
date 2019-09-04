enum SecretStoreKey { MONERO_WALLET_PASSWORD, PIN_CODE_PASSWORD }

const moneroWalletPassword = "MONERO_WALLET_PASSWORD";
const pinCodePassword = "PIN_CODE_PASSWORD";

String generateStoreKeyFor({SecretStoreKey key, String walletName = "",}) {
  var _key = "";

  switch (key) {
    case SecretStoreKey.MONERO_WALLET_PASSWORD:
      {
        _key = moneroWalletPassword + "_" + walletName.toUpperCase();
      }
      break;

    case SecretStoreKey.PIN_CODE_PASSWORD:
      {
        _key = pinCodePassword;
      }
      break;

    default:
      {}
  }

  return _key;
}