import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/src/widgets/alert_background.dart';
import 'package:cake_wallet/src/widgets/cake_scrollbar.dart';
import 'package:cake_wallet/src/widgets/alert_close_button.dart';

class Picker<Item extends Object> extends StatefulWidget {
  Picker({
    @required this.selectedAtIndex,
    @required this.items,
    this.images,
    @required this.title,
    @required this.onItemSelected,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.isAlwaysShowScrollThumb = false
  });

  final int selectedAtIndex;
  final List<Item> items;
  final List<Image> images;
  final String title;
  final Function(Item) onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final bool isAlwaysShowScrollThumb;

  @override
  PickerState createState() => PickerState<Item>(items, images, onItemSelected);
}

class PickerState<Item> extends State<Picker> {
  PickerState(this.items, this.images, this.onItemSelected);

  final Function(Item) onItemSelected;
  final List<Item> items;
  final List<Image> images;

  final closeButton = Image.asset('assets/images/close.png');
  ScrollController controller = ScrollController();

  final double backgroundHeight = 193;
  final double thumbHeight = 72;
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
                    widget.title,
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
                  padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                  child: GestureDetector(
                    onTap: () => null,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                      child: Container(
                          height: 233,
                          color: Theme.of(context).accentTextTheme.title.backgroundColor,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ListView.separated(
                                controller: controller,
                                separatorBuilder: (context, index) => Divider(
                                  color: Theme.of(context).dividerColor,
                                  height: 1,
                                ),
                                itemCount: items == null ? 0 : items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final image = images != null? images[index] : null;
                                  final isItemSelected = index == widget.selectedAtIndex;

                                  final color = isItemSelected
                                      ? Theme.of(context).accentTextTheme.subtitle.decorationColor
                                      : Colors.transparent;
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
                                      height: 77,
                                      padding: EdgeInsets.only(left: 24, right: 24),
                                      color: color,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: widget.mainAxisAlignment,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          image != null
                                              ? image
                                              : Offstage(),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: image != null ? 12 : 0
                                            ),
                                            child: Text(
                                              item.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              widget.isAlwaysShowScrollThumb
                              ? CakeScrollbar(
                                  backgroundHeight: backgroundHeight,
                                  thumbHeight: thumbHeight,
                                  fromTop: fromTop
                              )
                              : Offstage(),
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
