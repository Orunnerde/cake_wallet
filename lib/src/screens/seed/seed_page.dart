import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/stores/wallet_seed/wallet_seed_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class SeedPage extends BasePage {
  String get title => 'Seed';

  @override
  Widget body(BuildContext context) {
    final walletSeedStore = Provider.of<WalletSeedStore>(context);
    String _seed;

    return Form(
        child: GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: 30.0, top: 30.0, right: 30.0, bottom: 30.0),
                child: Observer(builder: (_) {
                  _seed = walletSeedStore.seed;
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Palette.lightGrey))),
                            padding: EdgeInsets.only(bottom: 20.0),
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              walletSeedStore.name,
                              textAlign: TextAlign.center,
                            ),
                          ))
                        ],
                      ),
                      Text(
                        walletSeedStore.seed,
                        textAlign: TextAlign.center,
                      )
                    ],
                  );
                }),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Please share, copy, or write down your seed. The seed '
                      'is used to recover your wallet. This is your PRIVATE '
                      'seed. DO NOT SHARE this seed with other people!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Palette.lightBlue,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                              child: Container(
                            padding: EdgeInsets.only(right: 15.0),
                            child: PrimaryButton(
                                onPressed: () {},
                                color: Palette.indigo,
                                borderColor: Palette.deepIndigo,
                                text: 'Save'),
                          )),
                          Flexible(
                              child: Container(
                            padding: EdgeInsets.only(left: 15.0),
                            child: PrimaryButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _seed));
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied to Clipboard'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(milliseconds: 1500),
                                    ),
                                  );
                                },
                                text: 'Copy'),
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
