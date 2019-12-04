import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';

class SeedAlert extends StatelessWidget{
  final imageSeed = Image.asset('assets/images/seedIco.png');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      imageSeed,
                      Text(
                        'The next page will show\nyou a seed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19.0
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                        'Please write these down just in\ncase you lose or wipe your phone.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 0.2,
                          fontSize: 16.0,
                          color: Palette.lightBlue
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'You can also see the seed again\nin the ',
                              style: TextStyle(
                                letterSpacing: 0.2,
                                fontSize: 16.0,
                                color: Palette.lightBlue
                              )
                            ),
                            TextSpan(
                              text: 'settings',
                              style: TextStyle(
                                letterSpacing: 0.2,
                                fontSize: 16.0,
                                color: Palette.lightGreen
                              )
                            ),
                            TextSpan(
                              text: ' menu.',
                              style: TextStyle(
                                letterSpacing: 0.2,
                                fontSize: 16.0,
                                color: Palette.lightBlue
                              )
                            ),
                          ]
                        )
                      )
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                onPressed: (){},
                text: 'I understand',
                color: Theme.of(context).primaryTextTheme.button.backgroundColor,
                borderColor: Theme.of(context).primaryTextTheme.button.decorationColor,
              ),
            ],
          ),
        )
      ),
    );
  }

}