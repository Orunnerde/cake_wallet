import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cake_wallet/src/screens/accounts/add_account.dart';

class Accounts extends StatefulWidget{

  final List<String> listAccounts;
  final int currentAccount;

  const Accounts(this.listAccounts, this.currentAccount);

  @override
  createState() => AccountsState(listAccounts, currentAccount);

}

class AccountsState extends State<Accounts>{
  final _key = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _editController = TextEditingController();

  List<String> _listAccounts;
  int _currentAccount;
  
  static final backArrowImage = Image.asset('assets/images/back_arrow.png');

  AccountsState(this._listAccounts, this._currentAccount);

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){ Navigator.pop(context); },
            child: backArrowImage
          ),
        ),
        middle: Text('Accounts', style: TextStyle(fontSize: 16.0),),
        trailing: Container(
          width: 28.0,
          height: 28.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Palette.purple
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(Icons.add, color: Palette.violet, size: 20.0),
              ButtonTheme(
                minWidth: 28.0,
                height: 28.0,
                child: FlatButton(
                  shape: CircleBorder(),
                  onPressed: () async {

                    var _accountName = await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => AddAccount()));

                    if (_accountName != null){

                      if (_listAccounts == null) _listAccounts = new List();

                      setState(() {
                        _listAccounts.add(_accountName);
                      });

                    }

                  },
                  child: Offstage()
                ),
              )
            ],
          )
        ),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 20.0
          ),
          child: ListView.builder(
            itemCount: _listAccounts == null? 0 : _listAccounts.length,
            itemBuilder: (BuildContext context, int index){
              return Slidable(
                key: Key(_listAccounts[index]),
                actionPane: SlidableDrawerActionPane(),
                child: Container(
                  color: _currentAccount == index? Palette.purple : Colors.white,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(_listAccounts[index],
                          style: TextStyle(fontSize: 16.0),
                        ),
                        onTap: (){
                          setState(() {
                            _currentAccount = index;
                          });
                        },
                      ),
                      Divider(
                        color: Palette.lightGrey,
                        height: 1.0,
                      )
                    ],
                  ),
                ),
                dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  closeOnCanceled: true,
                  onWillDismiss: (actionType){
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Remove account',
                            textAlign: TextAlign.center,
                          ),
                          content: Text('Are you sure that you want to remove selected account?', textAlign: TextAlign.center,),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: (){
                                Navigator.pop(context, false);
                              },
                              child: Text('Cancel')
                            ),
                            FlatButton(
                              onPressed: (){
                                Navigator.pop(context, true);
                              },
                              child: Text('Remove')
                            ),
                          ],
                        );
                      }
                    );
                  },
                  onDismissed: (actionType){
                    setState(() {
                      _listAccounts.removeAt(index);
                    });
                  },
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Edit',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () async {

                      _editController.text = '';

                      await showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('Account',
                              textAlign: TextAlign.center,
                            ),
                            content: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Enter new name of account',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Palette.lightGrey
                                        )
                                      )
                                    ),
                                    controller: _editController,
                                    validator: (value){
                                      String p = '[^ ]';
                                      RegExp regExp = new RegExp(p);
                                      if (regExp.hasMatch(value)) return null;
                                      else return 'Please enter a new name of account';
                                    },
                                  )
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')
                              ),
                              FlatButton(
                                onPressed: (){
                                  if (_formKey.currentState.validate()){
                                    Navigator.pop(context);
                                    setState(() {
                                      _listAccounts[index] = _editController.text;
                                    });
                                  }
                                },
                                  child: Text('OK')
                              ),
                            ],
                          );
                        }
                      );

                    },
                  ),
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: CupertinoIcons.delete,
                    onTap: (){
                      _key.currentState.showSnackBar(
                        SnackBar(
                          content: Text('Swipe right to left to delete account',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Palette.purple,
                        )
                      );
                    },
                  ),
                ],
              );
            }
          ),
        )
      ),
    );

  }
}