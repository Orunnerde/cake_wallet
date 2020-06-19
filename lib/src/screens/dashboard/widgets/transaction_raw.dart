import 'package:flutter/material.dart';
import 'package:cake_wallet/src/domain/common/transaction_direction.dart';
import 'package:cake_wallet/generated/i18n.dart';

class TransactionRow extends StatelessWidget {
  TransactionRow(
      {this.direction,
      this.formattedDate,
      this.formattedAmount,
      this.formattedFiatAmount,
      this.isPending,
      @required this.onTap});

  final VoidCallback onTap;
  final TransactionDirection direction;
  final String formattedDate;
  final String formattedAmount;
  final String formattedFiatAmount;
  final bool isPending;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border.all(
                width: 1,
                color: Theme.of(context).backgroundColor
            ),
          ),
          padding: EdgeInsets.only(left: 24, right: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryTextTheme.display3.color
              ),
              child: Image.asset(
                  direction == TransactionDirection.incoming
                      ? 'assets/images/down_arrow.png'
                      : 'assets/images/up_arrow.png'),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                height: 42,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              (direction == TransactionDirection.incoming
                                  ? S.of(context).received
                                  : S.of(context).sent) +
                                  (isPending ? S.of(context).pending : ''),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryTextTheme.title.color
                              )),
                          Text(direction == TransactionDirection.incoming
                              ? formattedAmount
                              : '- ' + formattedAmount,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryTextTheme.title.color
                              ))
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(formattedDate,
                              style: TextStyle(
                                  fontSize: 14, color: Theme.of(context).primaryTextTheme.headline.color)),
                          Text(direction == TransactionDirection.incoming
                              ? formattedFiatAmount
                              : '- ' + formattedFiatAmount,
                              style: TextStyle(
                                  fontSize: 14, color: Theme.of(context).primaryTextTheme.headline.color))
                        ]),
                  ],
                ),
              ),
            ))
          ]),
        ));
  }
}
