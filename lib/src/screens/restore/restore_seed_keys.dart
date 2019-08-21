import 'package:flutter/material.dart';
import 'package:cake_wallet/src/screens/restore/widgets/restore_button.dart';
import 'package:cake_wallet/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/routes.dart';

class RestoreSeedKeys extends StatelessWidget{

  static const _aspectRatioImage = 2.086;

  final _imageSeed = Image.asset('assets/images/seedIco.png');
  final _imageKeys = Image.asset('assets/images/keysIco.png');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: CupertinoNavigationBar(
          middle: Text('Restore'),
          backgroundColor: Colors.white,
          border: null,
        ),
        body: Container(
          padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
          ),
          child: Column(
            children: <Widget>[
              Flexible(
                child: RestoreButton(
                  onPressed: (){
                    Navigator.pushNamed(context, restoreFromSeedRoute);
                  },
                  image: _imageSeed,
                  aspectRatioImage: _aspectRatioImage,
                  title: 'Restore from seed',
                  description: 'Restore your wallet from either the 25 word\nor 13 word seed',
                  textButton: 'Next',
                )
              ),
              Flexible(
                child: RestoreButton(
                  onPressed: (){
                    Navigator.pushNamed(context, restoreFromKeysRoute);
                  },
                  image: _imageKeys,
                  aspectRatioImage: _aspectRatioImage,
                  color: Palette.lightGreen,
                  title: 'Restore from keys',
                  description: 'Restore your wallet from your private keys',
                  textButton: 'Next',
                )
              )
            ],
          ),
        )
    );

  }

}