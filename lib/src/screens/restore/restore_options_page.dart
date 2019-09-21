import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/screens/restore/widgets/restore_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class RestoreOptionsPage extends BasePage {
  static const _aspectRatioImage = 2.086;

  String get title => 'Restore';

  final _imageSeedKeys = Image.asset('assets/images/seedKeys.png');
  final _imageRestoreSeed = Image.asset('assets/images/restoreSeed.png');

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
                onPressed: () {
                  Navigator.pushNamed(context, Routes.restoreWalletOptionsFromWelcome);
                },
                image: _imageSeedKeys,
                aspectRatioImage: _aspectRatioImage,
                title: 'Restore from seed/keys',
                description: 'Restore your wallet from your seed or keys',
                textButton: 'Next',
              ),
            ),
            Flexible(
                child: RestoreButton(
              onPressed: () {},
              image: _imageRestoreSeed,
              aspectRatioImage: _aspectRatioImage,
              color: Palette.lightGreen,
              title: 'Restore from a back-up file',
              description:
                  'Restore the whole Cake Wallet app from\nyour back-up file',
              textButton: 'Next',
            ))
          ],
        ),
      );
}
