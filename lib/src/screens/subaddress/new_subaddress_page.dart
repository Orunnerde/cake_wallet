import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/stores/subaddress_creation/subaddress_creation_state.dart';
import 'package:cake_wallet/src/stores/subaddress_creation/subaddress_creation_store.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class NewSubaddressPage extends BasePage {
  String get title => 'New subaddress';

  @override
  Widget body(BuildContext context) => NewSubaddressForm();

  @override
  Widget build(BuildContext context) {
    final subaddressCreationStore =
        Provider.of<SubadrressCreationStore>(context);

    reaction((_) => subaddressCreationStore.state, (state) {
      if (state is SubaddressCreatedSuccessfully) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => Navigator.of(context).pop());
      }
    });

    return super.build(context);
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
    final subaddressCreationStore =
        Provider.of<SubadrressCreationStore>(context);

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
          child: Observer(
            builder: (_) => LoadingPrimaryButton(
                onPressed: () async =>
                    subaddressCreationStore.add(label: _labelController.text),
                text: 'Create',
                color: Color.fromRGBO(216, 223, 246, 0.7),
                borderColor: Color.fromRGBO(196, 206, 237, 1),
                isLoading:
                    subaddressCreationStore.state is SubaddressIsCreating),
          ))
    ]);
  }
}
