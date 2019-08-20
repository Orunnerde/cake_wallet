import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/src/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Disclaimer extends StatefulWidget{
  @override
  createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer>{

  static const url1 = 'https://xmr.to/app_static/html/tos.html';
  static const url2 = 'https://www.morphtoken.com/terms/';

  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            child: InkWell(
              onTap: (){},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.arrow_left),
                  Text('Settings')
                ],
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: 25.0,
                    right: 25.0
                ),
                child: Column(
                  children: <Widget>[
                    Text('Terms and conditions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Legal Disclaimer\nAnd\nTerms of Use',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('1.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('Use of Cake Wallet',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('The Cake Wallet app (hereinafter, referred to as the "App") '
                        'allows the use of accessing the Monero Blockchain/network. '
                        'You are not authorized, and nor should you rely on the App '
                        'for legal advice, business advice, or advice of any kind. '
                        'You act at your own risk in reliance on the contents of the App. '
                        'Should you make a decision to act or not act you should contact '
                        'a licensed attorney in the relevant jurisdiction in which you '
                        'want or need help. In no way are the owners of, or contributors to, '
                        'the App responsible for the actions, decisions, or other behavior '
                        'taken or not taken by you in reliance upon the App.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('2.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('Translations',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('The App may contain translations of the English version of '
                        'the content available on the App. These translations are provided '
                        'only as a convenience. In the event of any conflict between '
                        'the English language version and the translated version, the '
                        'English language version shall take precedence. If you notice '
                        'any inconsistency, please report them on GitHub.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('3.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('Risks related to the use of Cake Wallet',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('The App, the App’s owner Cake Technologies LLC and Cake Technologies '
                        'owners, partners, employees, contributors, and any affiliates will not '
                        'be responsible for any losses, damages or claims arising from events '
                        'falling within the scope of the following five categories:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('1.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('(1) Mistakes made by the user of any Monero-related '
                                'software or service, e.g., forgotten passwords, payments sent '
                                'to wrong Monero addresses, and accidental deletion of wallets.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('2.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('(2) Software problems of the App and/or any Monero-related '
                                'software or service, e.g., corrupted wallet file, incorrectly '
                                'constructed transactions, unsafe cryptographic libraries, '
                                'malware affecting the App and/or any Monero-related software or service.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('3.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('(3) Technical failures in the hardware of the user '
                                'of any Monero-related software or service, e.g., data loss '
                                'due to a faulty or damaged storage device.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('4.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('(4) Security problems experienced by the user '
                                'of any Monero-related software or service, e.g., unauthorized '
                                'access to users\' wallets and/or accounts.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('5.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('(5) Actions or inactions of third parties '
                                'and/or events experienced by third parties, e.g., '
                                'bankruptcy of service providers, information security '
                                'attacks on service providers, and fraud conducted by third parties.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('4.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('Investment risks',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('The investment in Monero can lead to loss of money over '
                        'short or even long periods. The investors in Monero should '
                        'expect prices to have large range fluctuations.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('5.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('Compliance with tax obligations',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('The users of the App are solely responsible to determinate '
                        'what, if any, taxes apply to their Monero transactions. The '
                        'owners of, or contributors to, the App are NOT responsible '
                        'for determining the taxes that apply to Monero transactions.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('6.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('The App does not store, send, or receive Moneros',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('The App does not store, send or receive Monero. This is because '
                        'Monero exists only by virtue of the ownership record maintained '
                        'in the Monero network. Any transfer of title in Moneros occurs '
                        'within a decentralized Monero network, and not on the App.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('7.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('No warranties',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('The App is provided on an "as is" basis without any warranties '
                        'of any kind regarding the App and/or any content, data, materials '
                        'and/or services provided on the App.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('8.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('Limitation of liability',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('Unless otherwise required by law, in no event shall the owners of, '
                        'or contributors to, the App be liable for any damages of any kind, '
                        'including, but not limited to, loss of use, loss of profits, or loss '
                        'of data arising out of or in any way connected with the use of the App.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('9.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('Arbitration',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('The user of the App agrees to arbitrate any dispute arising from or in '
                        'connection with the App or this disclaimer, except for disputes related '
                        'to copyrights, logos, trademarks, trade names, trade secrets or patents.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text('10.',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                            child: Text('Last amendment',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12.0),
                            )
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text('This disclaimer was amended for the last time on January 15, 2018',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Other Terms and Conditions',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => launch(url1),
                          child: Text(url1,
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => launch(url2),
                          child: Text(url2,
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    )
                  ],
                ),
              )
          ),
          CheckboxListTile(
            value: _checked,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('I agree to Terms of Use', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),),
            onChanged: (bool value) => setState(() => _checked = value),
          ),
          Container(
            padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                bottom: 25.0
            ),
            child: PrimaryButton(
                onPressed: _checked ? (){} : null,
                text: 'Accept'
            ),
          ),
        ],
      ),
    );

  }

}