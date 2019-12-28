import 'package:encrypt/encrypt.dart';
import 'package:password/password.dart';

const salt = '70082990395834992239721004668359';
const key = '90814651488338444282075623545945';
const walletSalt = '12345678';
const shortKey = '700829903958349922391195';

String encrypt({String source, String key, int keyLength = 16}) {
  final _key = Key.fromUtf8(key);
  final iv = IV.fromLength(keyLength);
  final encrypter = Encrypter(AES(_key));
  final encrypted = encrypter.encrypt(source, iv: iv);

  return encrypted.base64;
}

String decrypt({String source, String key, int keyLength = 16}) {
  final _key = Key.fromUtf8(key);
  final iv = IV.fromLength(keyLength);
  final encrypter = Encrypter(AES(_key));
  final decrypted = encrypter.decrypt64(source, iv: iv);

  return decrypted;
}

String hash({String source}) {
  final algorithm = PBKDF2();
  final hash = Password.hash(source, algorithm);

  return hash;
}

String getPinCodeRaw() {
  final pin = '1195';
  final source = hash(source: '$pin$salt');
  final encrypted = encrypt(source: source, key: key);

  return encrypted;
}

String encodedPinCode({String pin}) {
  final source = '$salt$pin';

  return encrypt(source: source, key: key);
}

String decodedPinCode({String pin}) {
  final decrypted = decrypt(source: pin, key: key);

  return decrypted.substring(key.length, decrypted.length);
}

String encodeWalletPassword({String password}) {
  // final pin = decodedPinCode();
  final source = password;
  final _key = shortKey + walletSalt;

  return encrypt(source: source, key: _key);
}

String decodeWalletPassword({String password}) {
  // final pin = decodedPinCode();
  final source = password;
  final _key = shortKey + walletSalt;

  return decrypt(source: source, key: _key);
}
