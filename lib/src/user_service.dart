import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cake_wallet/src/secret_store_key.dart';

class UserService {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  UserService({this.sharedPreferences, this.secureStorage});

  Future<void> setPassword(String password) async {
    final key = generateStoreKeyFor(key: SecretStoreKey.PIN_CODE_PASSWORD);
    await secureStorage.write(key: key, value: password);
  }

  Future<bool> canAuthenticate() async {
    final key = generateStoreKeyFor(key: SecretStoreKey.PIN_CODE_PASSWORD);
    final sharedPreferences = await SharedPreferences.getInstance();
    final walletName = sharedPreferences.getString("current_wallet_name") ?? "";
    final password = await secureStorage.read(key: key) ?? "";

    return walletName.isNotEmpty && password.isNotEmpty;
  }

  Future<bool> authenticate(String pin) async {
    final key = generateStoreKeyFor(key: SecretStoreKey.PIN_CODE_PASSWORD);
    final original = await secureStorage.read(key: key);

    return original == pin;
  }
}