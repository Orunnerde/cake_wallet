import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/domain/common/secret_store_key.dart';

class UserService {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  UserService({this.sharedPreferences, this.secureStorage});

  Future<void> setPassword(String password) async {
    final key = generateStoreKeyFor(key: SecretStoreKey.PIN_CODE_PASSWORD);
    try {
      await secureStorage.write(key: key, value: password);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> canAuthenticate() async {
    final key = generateStoreKeyFor(key: SecretStoreKey.PIN_CODE_PASSWORD);
    final sharedPreferences = await SharedPreferences.getInstance();
    final walletName = sharedPreferences.getString("current_wallet_name") ?? "";
    var password = '';

    try {
      password = await secureStorage.read(key: key);
    } catch (e) {
      print(e);
    }

    return walletName.isNotEmpty && password.isNotEmpty;
  }

  Future<bool> authenticate(String pin) async {
    final key = generateStoreKeyFor(key: SecretStoreKey.PIN_CODE_PASSWORD);
    final original = await secureStorage.read(key: key);

    return original == pin;
  }
}
