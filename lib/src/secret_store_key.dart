enum SecretStoreKey { MONERO_WALLET_PASSWORD, PIN_CODE_PASSWORD }

const MONERO_WALLET_PASSWORD = "MONERO_WALLET_PASSWORD";
const PIN_CODE_PASSWORD = "PIN_CODE_PASSWORD";

String generateStoreKeyFor({SecretStoreKey key, String walletName = "",}) {
  var _key = "";

  switch (key) {
    case SecretStoreKey.MONERO_WALLET_PASSWORD:
      {
        _key = MONERO_WALLET_PASSWORD + "_" + walletName.toUpperCase();
      }
      break;

    case SecretStoreKey.PIN_CODE_PASSWORD:
      {
        _key = PIN_CODE_PASSWORD;
      }
      break;

    default:
      {}
  }

  return _key;
}