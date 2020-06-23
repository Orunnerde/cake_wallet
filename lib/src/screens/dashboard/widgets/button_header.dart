import 'package:cake_wallet/src/domain/exchange/exchange_provider_description.dart';
import 'package:cake_wallet/src/stores/action_list/action_list_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cake_wallet/generated/i18n.dart';
import 'package:provider/provider.dart';
import 'package:cake_wallet/routes.dart';
import 'package:date_range_picker/date_range_picker.dart' as date_rage_picker;
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/src/widgets/filter_widget.dart';
import 'package:cake_wallet/src/widgets/checkbox_widget.dart';
import 'package:cake_wallet/src/screens/dashboard/widgets/filter_tile.dart';

class ButtonHeader extends SliverPersistentHeaderDelegate {
  final sendImage = Image.asset('assets/images/send.png');
  final exchangeImage = Image.asset('assets/images/exchange.png');
  final buyImage = Image.asset('assets/images/coins.png');

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final actionListStore = Provider.of<ActionListStore>(context);
    final historyPanelWidth = MediaQuery.of(context).size.width;

    final shortDivider = Container(
      height: 1,
      padding: EdgeInsets.only(left: 24),
      color: Theme.of(context).accentTextTheme.title.backgroundColor,
      child: Container(
        height: 1,
        color: Theme.of(context).dividerColor,
      ),
    );

    final longDivider = Container(
      height: 1,
      color: Theme.of(context).dividerColor,
    );

    final _themeChanger = Provider.of<ThemeChanger>(context);
    Image filterButton;

    if (_themeChanger.getTheme() == Themes.darkTheme) {
      filterButton = Image.asset('assets/images/filter_button.png');
    } else {
      filterButton = Image.asset('assets/images/filter_light_button.png');
    }

    double buttonsOpacity = 1 - shrinkOffset / (maxExtent - minExtent);
    double buttonsHeight = maxExtent - minExtent - shrinkOffset;

    buttonsOpacity = buttonsOpacity >= 0 ? buttonsOpacity : 0;
    buttonsHeight = buttonsHeight >= 0 ? buttonsHeight : 0;

    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: <Widget>[
        Opacity(
          opacity: buttonsOpacity,
          child: Container(
            height: buttonsHeight,
            padding: EdgeInsets.only(left: 44, right: 44),
            child: Row(
              children: <Widget>[
                Flexible(
                    child: actionButton(
                        context: context,
                        image: sendImage,
                        title: S.of(context).send,
                        route: Routes.send
                    )
                ),
                Flexible(
                    child: actionButton(
                        context: context,
                        image: exchangeImage,
                        title: S.of(context).exchange,
                        route: Routes.exchange
                    )
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: buttonsHeight,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Container(
                width: historyPanelWidth,
                height: 66,
                padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
                color: Theme.of(context).backgroundColor,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Text(
                      S.of(context).transactions,
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryTextTheme.title.color
                      ),
                    ),
                    Positioned(
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          showDialog<void>(
                              context: context,
                              builder: (_) {
                                return FilterWidget(
                                    title: S.of(context).filter,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 24,
                                              left: 24,
                                              right: 24
                                          ),
                                          child: Text(
                                            S.of(context).transactions,
                                            style: TextStyle(
                                                color: Theme.of(context).primaryTextTheme.caption.color,
                                                fontSize: 16,
                                                decoration: TextDecoration.none
                                            ),
                                          ),
                                        ),
                                        FilterTile(
                                          child: CheckboxWidget(
                                              caption: S.of(context).incoming,
                                              value: actionListStore
                                                  .transactionFilterStore
                                                  .displayIncoming,
                                              onChanged: (value) => actionListStore
                                                  .transactionFilterStore
                                                  .toggleIncoming()
                                          )
                                        ),
                                        shortDivider,
                                        FilterTile(
                                          child: CheckboxWidget(
                                              caption: S.of(context).outgoing,
                                              value: actionListStore
                                                  .transactionFilterStore
                                                  .displayOutgoing,
                                              onChanged: (value) => actionListStore
                                                  .transactionFilterStore
                                                  .toggleOutgoing()
                                          ),
                                        ),
                                        shortDivider,
                                        FilterTile(
                                            child: GestureDetector(
                                              onTap: () async {
                                                final List<DateTime> picked =
                                                await date_rage_picker.showDatePicker(
                                                    context: context,
                                                    initialFirstDate: DateTime.now()
                                                        .subtract(Duration(days: 1)),
                                                    initialLastDate: (DateTime.now()),
                                                    firstDate: DateTime(2015),
                                                    lastDate: DateTime.now()
                                                        .add(Duration(days: 1)));

                                                if (picked != null && picked.length == 2) {
                                                  actionListStore.transactionFilterStore
                                                      .changeStartDate(picked.first);
                                                  actionListStore.transactionFilterStore
                                                      .changeEndDate(picked.last);
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 32),
                                                child: Text(
                                                  S.of(context).transactions_by_date,
                                                  style: TextStyle(
                                                      color: Theme.of(context).primaryTextTheme.title.color,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w600,
                                                      decoration: TextDecoration.none
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                        longDivider,
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 24,
                                              left: 24,
                                              right: 24
                                          ),
                                          child: Text(
                                            S.of(context).trades,
                                            style: TextStyle(
                                                color: Theme.of(context).primaryTextTheme.caption.color,
                                                fontSize: 16,
                                                decoration: TextDecoration.none
                                            ),
                                          ),
                                        ),
                                        FilterTile(
                                            child: CheckboxWidget(
                                                caption: 'XMR.TO',
                                                value: actionListStore
                                                    .tradeFilterStore
                                                    .displayXMRTO,
                                                onChanged: (value) => actionListStore
                                                    .tradeFilterStore
                                                    .toggleDisplayExchange(
                                                    ExchangeProviderDescription
                                                        .xmrto)
                                            )
                                        ),
                                        shortDivider,
                                        FilterTile(
                                            child: CheckboxWidget(
                                                caption: 'Change.NOW',
                                                value: actionListStore
                                                    .tradeFilterStore
                                                    .displayChangeNow,
                                                onChanged: (value) => actionListStore
                                                    .tradeFilterStore
                                                    .toggleDisplayExchange(
                                                    ExchangeProviderDescription
                                                        .changeNow)
                                            )
                                        ),
                                        shortDivider,
                                        FilterTile(
                                            child: CheckboxWidget(
                                                caption: 'MorphToken',
                                                value: actionListStore
                                                    .tradeFilterStore
                                                    .displayMorphToken,
                                                onChanged: (value) => actionListStore
                                                    .tradeFilterStore
                                                    .toggleDisplayExchange(
                                                    ExchangeProviderDescription
                                                        .morphToken)
                                            )
                                        )
                                      ],
                                    )
                                );
                              }
                          );
                        },
                        child: filterButton,
                      )
                    )
                  ],
                ),
              ),
            )
        )
      ],
    );
  }

  @override
  double get maxExtent => 164;

  @override
  double get minExtent => 66;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  Widget actionButton({
    BuildContext context,
    @required Image image,
    @required String title,
    @required String route}) {

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (route.isNotEmpty) {
                Navigator.of(context, rootNavigator: true).pushNamed(route);
              }
            },
            child: Container(
              height: 48,
              width: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryTextTheme.subhead.color,
                  shape: BoxShape.circle
              ),
              child: image,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).primaryTextTheme.caption.color
              ),
            ),
          )
        ],
      ),
    );
  }
}