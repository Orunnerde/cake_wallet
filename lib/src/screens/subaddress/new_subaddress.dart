import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/dashboard/sync_info.dart';

class NewSubaddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color.fromRGBO(253, 253, 253, 1),
        appBar: CupertinoNavigationBar(
          middle: Text('New subaddress',
              style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(34, 40, 75, 1),
                  fontFamily: 'Lato')),
          backgroundColor: Colors.white,
          border: null,
        ),
        body: NewSubaddressForm());
  }
}

class NewSubaddressForm extends StatefulWidget {
  @override
  NewSubaddressFormState createState() => NewSubaddressFormState();
}

class NewSubaddressFormState extends State<NewSubaddressForm> {
  final _labelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Center(
        child: Padding(
          padding: EdgeInsets.only(left: 35, right: 35),
          child: TextFormField(
              controller: _labelController,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Palette.lightBlue),
                  hintText: 'Label name',
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.lightGrey, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.lightGrey, width: 2.0))),
              validator: (value) => null),
        ),
      ),
      Positioned(
        bottom: 20,
        left: 20,
        right: 20,
        child: Consumer<NewSubaddressInfo>(
            builder: (context, subaddressList, child) {
          if (subaddressList.state == SubaddressCrationState.CREATED) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => Navigator.of(context).pop());
          }

          return LoadingPrimaryButton(
              onPressed: () async =>
                  subaddressList.add(label: _labelController.text),
              text: 'Create',
              color: Color.fromRGBO(216, 223, 246, 0.7),
              borderColor: Color.fromRGBO(196, 206, 237, 1),
              isLoading:
                  subaddressList.state == SubaddressCrationState.CREATING);
        }),
      )
    ]);
  }
}
