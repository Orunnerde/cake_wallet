import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/src/domain/common/fiat_currency.dart';
import 'package:cake_wallet/src/widgets/alert_background.dart';
import 'package:cake_wallet/src/widgets/cake_scrollbar.dart';
import 'package:cake_wallet/src/widgets/alert_close_button.dart';

class FiatCurrencyPicker extends StatefulWidget {
  FiatCurrencyPicker({
    @required this.selectedAtIndex,
    @required this.items,
    @required this.title,
    @required this.onItemSelected,
  });

  final int selectedAtIndex;
  final List<FiatCurrency> items;
  final String title;
  final Function(FiatCurrency) onItemSelected;

  @override
  FiatCurrencyPickerState createState() => FiatCurrencyPickerState(
    selectedAtIndex: selectedAtIndex,
    items: items,
    title: title,
    onItemSelected: onItemSelected
  );
}

class FiatCurrencyPickerState extends State<FiatCurrencyPicker> {
  FiatCurrencyPickerState({
    @required this.selectedAtIndex,
    @required this.items,
    @required this.title,
    @required this.onItemSelected,
  });

  final int selectedAtIndex;
  final List<FiatCurrency> items;
  final String title;
  final Function(FiatCurrency) onItemSelected;

  final closeButton = Image.asset('assets/images/close.png');
  ScrollController controller = ScrollController();

  final double backgroundHeight = 360;
  final double thumbHeight = 142;
  double fromTop = 0;

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      fromTop = controller.hasClients
          ? (controller.offset / controller.position.maxScrollExtent * (backgroundHeight - thumbHeight))
          : 0;
      setState(() {});
    });

    return AlertBackground(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Colors.white
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: GestureDetector(
                  onTap: () => null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    child: Container(
                      height: 400,
                      width: 300,
                      color: Theme.of(context).dividerColor,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          GridView.count(
                              controller: controller,
                              crossAxisCount: 3,
                              childAspectRatio: 1.25,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                              children: List.generate(items.length, (index) {

                                final item = items[index];
                                final isItemSelected = index == selectedAtIndex;

                                final color = isItemSelected
                                    ? Theme.of(context).accentTextTheme.subtitle.decorationColor
                                    : Theme.of(context).primaryTextTheme.display1.color;
                                final textColor = isItemSelected
                                    ? Colors.blue
                                    : Theme.of(context).primaryTextTheme.title.color;

                                return GestureDetector(
                                  onTap: () {
                                    if (onItemSelected == null) {
                                      return;
                                    }
                                    Navigator.of(context).pop();
                                    onItemSelected(item);
                                  },
                                  child: Container(
                                    color: color,
                                    child: Center(
                                      child: Text(
                                        item.toString(),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.none,
                                            color: textColor
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          ),
                          CakeScrollbar(
                              backgroundHeight: backgroundHeight,
                              thumbHeight: thumbHeight,
                              fromTop: fromTop
                          )
                        ],
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
          AlertCloseButton(image: closeButton)
        ],
      )
    );
  }
}