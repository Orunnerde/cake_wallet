import 'package:cake_wallet/src/stores/account_list/account_list_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:provider/provider.dart';

class AccountPage extends BasePage {
  String get title => 'Account';

  @override
  Widget body(BuildContext context) => AccountForm();
}

class AccountForm extends StatefulWidget {
  @override
  createState() => AccountFormState();
}

class AccountFormState extends State<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountListStore = Provider.of<AccountListStore>(context);

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Expanded(
                child: Center(
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Theme.of(context).hintColor
                        ),
                        hintText: 'Account',
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(
                                color: Theme.of(context).focusColor,
                                width: 1.0
                            )),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(
                                color: Theme.of(context).focusColor,
                                width: 1.0
                            ))),
                controller: _textController,
                validator: (value) {
                  accountListStore.validateAccountName(value);
                  return accountListStore.errorMessage;
                },
              ),
            )),
            PrimaryButton(
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  return;
                }

                await accountListStore.addAccount(
                    label: _textController.text);
                Navigator.pop(context, _textController.text);
              },
              text: 'Add',
              color: Theme.of(context).primaryTextTheme.button.backgroundColor,
              borderColor: Theme.of(context).primaryTextTheme.button.decorationColor,
            )
          ],
        ),
      ),
    );
  }
}