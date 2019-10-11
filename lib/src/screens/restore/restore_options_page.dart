import 'package:flutter/material.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/screens/restore/widgets/restore_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class RestoreOptionsPage extends BasePage {
  static const _aspectRatioImage = 2.086;

  String get title => 'Restore Wallet';
  Color get backgroundColor => Palette.creamyGrey;

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
                description: "Get back your wallet from seed/keys that you've saved to secure place",
                textButton: 'Next',
              ),
            ),
            Flexible(
                child: RestoreButton(
              onPressed: () {},
              image: _imageRestoreSeed,
              aspectRatioImage: _aspectRatioImage,
              titleColor: Color.fromRGBO(41, 187, 244, 1),
              color: Color.fromRGBO(41, 187, 244, 1),
              title: 'Restore from a back-up file',
              description:
                  'You can restore the whole Cake Wallet app from\nyour back-up file',
              textButton: 'Next',
            ))
          ],
        ),
      );
}
