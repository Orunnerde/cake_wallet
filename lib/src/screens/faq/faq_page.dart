import 'package:flutter/material.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class FaqPage extends BasePage {
  String get title => 'FAQ';

  @override
  Widget body(BuildContext context) {

    return FutureBuilder(
      builder: (context, snapshot) {
        var faqItems = json.decode(snapshot.data.toString());

        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            final itemTitle = faqItems[index]["question"];
            final itemChild = faqItems[index]["answer"];

            return ExpansionTile(
              title: Text(
                itemTitle
              ),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 15.0,
                              right: 15.0
                          ),
                          child: Text(
                            itemChild,
                          ),
                        )
                    )
                  ],
                )
              ],
            );
          },
          separatorBuilder: (_, __) => Divider(
            color: Theme.of(context).dividerTheme.color,
            height: 1.0,
          ),
          itemCount: faqItems == null ? 0 : faqItems.length,
        );
      },
      future: rootBundle.loadString('assets/faq/faq.json'),
    );
  }

}