import 'package:cake_wallet/entities/wallet_info.dart';

abstract class WalletCredentials {
  WalletCredentials({this.name, this.password, this.height});

  final String name;
  final int height;
  String password;
  WalletInfo walletInfo;
}
