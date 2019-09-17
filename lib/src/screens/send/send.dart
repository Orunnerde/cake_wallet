import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/dashboard/sync_info.dart';
import 'package:cake_wallet/src/domain/common/transaction_priority.dart';

import 'package:barcode_scan/barcode_scan.dart';

class Send extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color.fromRGBO(253, 253, 253, 1),
        appBar: CupertinoNavigationBar(
          leading: SizedBox(
            height: 37,
            width: 37,
            child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () => Navigator.of(context).pop(),
                child: Image.asset('assets/images/close_button.png')),
          ),
          middle: Text('Send Monero',
              style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(34, 40, 75, 1),
                  fontFamily: 'Lato')),
          backgroundColor: Colors.white,
          border: null,
        ),
        body: SendForm());
  }
}

class SendForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SendFormState();
}

class SendFormState extends State<SendForm> {
  final _addressController = TextEditingController();
  final _paymentIdController = TextEditingController();
  final _cryptoAmountController = TextEditingController();
  final _fiatAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SendInfo>(context);

    provider.addListener(() {
      if (provider.fiatAmount != _fiatAmountController.text) {
        _fiatAmountController.text = provider.fiatAmount;
      }

      if (provider.cryptoAmount != _cryptoAmountController.text) {
        _cryptoAmountController.text = provider.cryptoAmount;
      }
    });

    _fiatAmountController.addListener(() {
      final fiatAmount = _fiatAmountController.text;

      if (provider.fiatAmount != fiatAmount) {
        provider.fiatAmount = fiatAmount;
      }
    });

    _cryptoAmountController.addListener(() {
      final cryptoAmount = _cryptoAmountController.text;

      if (provider.cryptoAmount != cryptoAmount) {
        provider.cryptoAmount = cryptoAmount;
      }
    });

    return Consumer<SendInfo>(builder: (context, sendInfo, child) {
      if (provider.state == SendState.ERROR) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(provider.error.toString()),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          provider.resetError();
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        });
      }

      if (provider.state == SendState.TRANSACTION_CREATED) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm sending'),
                  content: Text(
                      'Commit transaction\nAmount: ${provider.pendingTransaction.amount}\nFee: ${provider.pendingTransaction.fee}'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          provider.commitTransaction();
                        }),
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              });
        });
      }

      if (provider.state == SendState.COMMITTED) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Sending'),
                  content: Text('Transaction sent!'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () {
                          _addressController.text = '';
                          _cryptoAmountController.text = '';
                          provider.resetError();
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        });
      }

      return Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 38, right: 30),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(132, 141, 198, 0.14),
                  blurRadius: 10,
                  offset: Offset(
                    0,
                    12,
                  ),
                )
              ],
              border: Border(
                  top: BorderSide(
                      width: 1, color: Color.fromRGBO(242, 244, 247, 1)))),
          child: SizedBox(
            height: 76,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Consumer<WalletInfo>(builder: (context, walletInfo, child) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Your wallet',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(131, 87, 255, 1))),
                        Text(walletInfo.name,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(34, 40, 74, 1),
                                height: 1.25)),
                      ]);
                }),
                Consumer<BalanceInfo>(builder: (context, balanceInfo, child) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('XMR Balance',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(34, 40, 74, 1))),
                        Text(balanceInfo.unlockedBalance,
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(34, 40, 74, 1),
                                height: 1.1)),
                      ]);
                })
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 38, right: 33),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(children: <Widget>[
                      TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                              suffixIcon: Container(
                                  width: 34,
                                  height: 34,
                                  padding: EdgeInsets.only(top: 0),
                                  child: FlatButton(
                                    padding: EdgeInsets.all(0),
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          String code =
                                              await BarcodeScanner.scan();
                                          var uri = Uri.parse(code);
                                          var address = '';
                                          var amount = '';
                                          var paymentId = '';

                                          if (uri != null) {
                                            address = uri.path;
                                            amount = uri
                                                .queryParameters['tx_amount'];
                                            paymentId = uri.queryParameters[
                                                'tx_payment_id'];
                                          } else {
                                            address = code;
                                          }

                                          _addressController.text = address;
                                          _cryptoAmountController.text = amount;
                                          _paymentIdController.text = paymentId;
                                        } catch (e) {
                                          print('Error $e');
                                        }
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  155, 172, 197, 0.1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8))),
                                          child: Image.asset(
                                              'assets/images/qr_code_icon.png')),
                                    ),
                                    onPressed: () {},
                                  )),
                              hintStyle: TextStyle(color: Palette.lightBlue),
                              hintText: 'Monero address',
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Palette.lightGrey, width: 2.0)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Palette.lightGrey, width: 2.0))),
                          validator: (value) => null),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                            controller: _paymentIdController,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: Palette.lightBlue),
                                hintText: 'Payment ID (optional)',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Palette.lightGrey, width: 2.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Palette.lightGrey, width: 2.0))),
                            validator: (value) => null),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                            controller: _cryptoAmountController,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text('XMR:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromRGBO(34, 40, 74, 1))),
                                ),
                                suffixIcon: Container(
                                  width: 1,
                                  padding: EdgeInsets.only(top: 0),
                                  child: Center(
                                    child: InkWell(
                                        onTap: () {
                                          sendInfo.needToSendAll = true;
                                        },
                                        child: Text('ALL',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromRGBO(
                                                    138, 153, 175, 1)))),
                                  ),
                                ),
                                hintStyle: TextStyle(color: Palette.lightBlue),
                                hintText: '0.0000',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Palette.lightGrey, width: 2.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Palette.lightGrey, width: 2.0))),
                            validator: (value) => null),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                            controller: _fiatAmountController,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Text('USD:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromRGBO(34, 40, 74, 1))),
                                ),
                                hintStyle: TextStyle(color: Palette.lightBlue),
                                hintText: '0.00',
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Palette.lightGrey, width: 2.0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Palette.lightGrey, width: 2.0))),
                            validator: (value) => null),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Estimated fee:',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(34, 40, 75, 1))),
                            Text('XMR 0.00003121',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(34, 40, 75, 1)))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                            'Currently the fee is set at ${priorityToString(sendInfo.priority)} priority.\nTransaction priority can be adjusted in the settings',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(155, 172, 197, 1),
                                height: 1.3)),
                      ),
                    ]),
                    Consumer<SendInfo>(builder: (context, sendInfo, child) {
                      return LoadingPrimaryButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Creating transaction'),
                                    content: Text('Confirm sending'),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text("Send"),
                                          onPressed: () async {
                                            sendInfo.createTransaction(
                                                address:
                                                    _addressController.text,
                                                paymentId:
                                                    _paymentIdController.text);
                                            Navigator.of(context).pop();
                                          }),
                                      FlatButton(
                                          child: Text("Cancel"),
                                          onPressed: () =>
                                              Navigator.of(context).pop())
                                    ],
                                  );
                                });
                          },
                          text: 'Send',
                          color: Color.fromRGBO(216, 223, 246, 0.7),
                          borderColor: Color.fromRGBO(196, 206, 237, 1),
                          isLoading: sendInfo.state ==
                                  SendState.CREATING_TRANSACTION ||
                              sendInfo.state == SendState.COMMITTING);
                    })
                  ])),
        )
      ]);
    });
  }
}
