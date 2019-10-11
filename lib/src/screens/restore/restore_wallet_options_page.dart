import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/restore/widgets/restore_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class RestoreWalletOptionsPage extends BasePage {
  static const _aspectRatioImage = 2.086;

  String get title => 'Seed/Keys Restore';
  Color get backgroundColor => Palette.creamyGrey;

  final _imageSeed = Image.asset('assets/images/seedIco.png');
  final _imageKeys = Image.asset('assets/images/keysIco.png');

  @override
  Widget body(BuildContext context) => Container(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        child: Column(
          children: <Widget>[
            Flexible(
                child: RestoreButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.restoreWalletFromSeed),
              image: _imageSeed,
              aspectRatioImage: _aspectRatioImage,
                  titleColor: Palette.lightViolet,
                  color: Palette.lightViolet,
              title: 'Restore from seed',
              description:
                  'Restore your wallet from either the 25 word\nor 13 word combination code',
              textButton: 'Next',
            )),
            Flexible(
                child: RestoreButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.restoreWalletFromKeys),
              image: _imageKeys,
              aspectRatioImage: _aspectRatioImage,
                  titleColor: Palette.cakeGreen,
                  color: Palette.cakeGreen,
              title: 'Restore from keys',
              description: 'Restore your wallet from generated\nkeystrokes saved from your private keys',
              textButton: 'Next',
            ))
          ],
        ),
      );
}
