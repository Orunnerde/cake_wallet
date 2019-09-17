import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/src/domain/common/wallet_description.dart';
import 'package:cake_wallet/src/screens/auth/auth.dart';
import 'package:cake_wallet/src/screens/dashboard/sync_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/palette.dart';

class WalletListScreen extends StatelessWidget {
  final _closeButtonImage = Image.asset('assets/images/close_button.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CupertinoNavigationBar(
          leading: ButtonTheme(
            minWidth: double.minPositive,
            child: FlatButton(
                padding: EdgeInsets.all(0), onPressed: () => Navigator.of(context).pop(), child: _closeButtonImage),
          ),
          middle: Text(
            'Wallet list',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          border: null,
        ),
        body: WalletListBody());
  }
}

class WalletListBody extends StatelessWidget {
  final _closeButtonImage = Image.asset('assets/images/close_button.png');
  WalletListInfo _walletListInfo;

  void presetMenuForWallet(WalletDescription wallet, bool isCurrentWallet, BuildContext bodyContext) {
    showDialog(
        context: bodyContext,
        builder: (context) {
          return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            CupertinoActionSheet(
              actions: _generateActionsForWalletActionSheets(wallet, isCurrentWallet, context, bodyContext),
              cancelButton: CupertinoActionSheetAction(
                  child: const Text('Cancel'), isDefaultAction: true, onPressed: () => Navigator.of(context).pop()),
            )
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    _walletListInfo = Provider.of<WalletListInfo>(context);

    return Consumer<WalletListInfo>(builder: (_, walletList, child) {
      return SafeArea(
          child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Expanded(
              child: Stack(
            children: <Widget>[
              Container(
                height: 10.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Palette.lightGrey2, Colors.white],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(0.0, 1.0),
                )),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: ListView.separated(
                            separatorBuilder: (_, index) {
                              return Divider(color: Palette.lightGrey, height: 3.0);
                            },
                            itemCount: walletList.wallets.length,
                            itemBuilder: (__, index) {
                              final wallet = walletList.wallets[index];
                              final isCurrentWallet = walletList.isCurrentWallet(wallet);

                              return InkWell(
                                  onTap: () => presetMenuForWallet(wallet, isCurrentWallet, context),
                                  child: Container(
                                      child: ListTile(
                                    title: Text(
                                      wallet.name,
                                      style: TextStyle(
                                          color: isCurrentWallet ? Palette.cakeGreen : Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    trailing: isCurrentWallet
                                        ? Icon(
                                            Icons.check,
                                            color: Palette.cakeGreen,
                                            size: 20.0,
                                          )
                                        : null
                                  )));
                            })),
                    SizedBox(
                      height: 10.0,
                    ),
                    PrimaryIconButton(
                        onPressed: () => Navigator.of(context).pushNamed(newWalletRoute),
                        iconData: Icons.add,
                        iconColor: Palette.violet,
                        text: 'Create New Wallet'),
                    SizedBox(
                      height: 10.0,
                    ),
                    PrimaryIconButton(
                      onPressed: () => Navigator.of(context).pushNamed(restoreSeedKeysRoute),
                      iconData: Icons.refresh,
                      text: 'Restore Wallet',
                      color: Palette.indigo,
                      borderColor: Palette.deepIndigo,
                    ),
                  ],
                ),
              ),
            ],
          ))
        ],
      ));
    });
  }

  List<Widget> _generateActionsForWalletActionSheets(
      WalletDescription wallet, bool isCurrentWallet, BuildContext context, BuildContext bodyContext) {
    List<Widget> actions = [];

    if (!isCurrentWallet) {
      actions.add(CupertinoActionSheetAction(
          child: const Text('Load wallet'),
          onPressed: () async {
            Navigator.of(context).popAndPushNamed(authRoute, arguments: <void Function(Auth)>[
              (auth) async {
                try {
                  auth.changeProcessText('Loading ${wallet.name} wallet');
                  await _walletListInfo.loadWallet(wallet);
                  auth.close();
                  Navigator.of(bodyContext).pop();
                } catch (e) {
                  auth.changeProcessText('Failed to load ${wallet.name} wallet. ${e.toString()}');
                }
              }
            ]);
          }));
    }

    actions.add(CupertinoActionSheetAction(
        child: const Text('Show seed'),
        onPressed: () async {
          Navigator.of(context).popAndPushNamed(authRoute, arguments: <void Function(Auth)>[
            (auth) async {
              auth.close();
              Navigator.of(bodyContext).popAndPushNamed(seedRoute);
            }
          ]);
        }));

    if (!isCurrentWallet) {
      actions.add(CupertinoActionSheetAction(
          child: const Text('Remove'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).popAndPushNamed(authRoute, arguments: <void Function(Auth)>[
              (auth) async {
                try {
                  auth.changeProcessText('Removing ${wallet.name} wallet');
                  await _walletListInfo.remove(wallet);
                  auth.close();
                } catch (e) {
                  auth.changeProcessText('Failed to remove ${wallet.name} wallet. ${e.toString()}');
                }
              }
            ]);
          }));
    }

    return actions;
  }
}
