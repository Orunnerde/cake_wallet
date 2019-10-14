import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/stores/subaddress_list/subaddress_list_store.dart';
import 'package:cake_wallet/src/stores/wallet/wallet_store.dart';
import 'package:cake_wallet/src/screens/receive/qr_image.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class ReceivePage extends BasePage {
  bool get isModalBackButton => true;
  String get title => 'Receive';

  final _shareButtonImage = Image.asset('assets/images/share_button.png');

  @override
  Widget trailing(BuildContext context) => ButtonTheme(
        minWidth: double.minPositive,
        child: FlatButton(onPressed: () {}, child: _shareButtonImage),
      );

  @override
  Widget body(BuildContext context) =>
      SingleChildScrollView(child: ReceiveBody());
}

class ReceiveBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletStore = Provider.of<WalletStore>(context);
    final subaddressListStore = Provider.of<SubaddressListStore>(context);

    return SafeArea(
        child: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(35.0),
          child: Column(
            children: <Widget>[
              Observer(builder: (_) {
                return Row(
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    Flexible(
                        flex: 2,
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: QrImage(
                            data: walletStore.subaddress.address,
                            backgroundColor: Colors.white,
                          ),
                        )),
                    Spacer(
                      flex: 1,
                    )
                  ],
                );
              }),
              Observer(builder: (_) {
                return Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                text: walletStore.subaddress.address));
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Copied to Clipboard',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                              backgroundColor: Palette.purple,
                            ));
                          },
                          child: Text(
                            walletStore.subaddress.address,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ))
                  ],
                );
              }),
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Palette.lightBlue),
                        hintText: 'Amount',
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Palette.lightGrey, width: 2.0)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Palette.lightGrey, width: 2.0))),
                    onSubmitted: (value) {
                      // _validateAmount(value);
                    },
                  ))
                ],
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: Container(
              color: Palette.lightGrey2,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Subaddresses',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    trailing: Container(
                      width: 28.0,
                      height: 28.0,
                      decoration: BoxDecoration(
                          color: Palette.purple, shape: BoxShape.circle),
                      child: InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed(Routes.newSubaddress),
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        child: Icon(
                          Icons.add,
                          color: Palette.violet,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Palette.lightGrey,
                    height: 1.0,
                  )
                ],
              ),
            ))
          ],
        ),
        Observer(builder: (_) {
          return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: subaddressListStore.subaddresses.length,
              separatorBuilder: (context, i) {
                return Divider(
                  color: Palette.lightGrey,
                  height: 1.0,
                );
              },
              itemBuilder: (context, i) {
                return Observer(builder: (_) {
                  final subaddress = subaddressListStore.subaddresses[i];
                  final isCurrent =
                      walletStore.subaddress.address == subaddress.address;
                  final label = subaddress.label.isNotEmpty
                      ? subaddress.label
                      : subaddress.address;

                  return Container(
                    color: isCurrent ? Palette.purple : Palette.lightGrey2,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            label,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          onTap: () => walletStore.setSubaddress(subaddress),
                        ),
                      ],
                    ),
                  );
                });
              });
        })
      ],
    )));
  }
}
