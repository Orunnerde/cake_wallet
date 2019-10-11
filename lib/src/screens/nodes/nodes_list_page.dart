import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/stores/node_list/node_list_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';
import 'package:cake_wallet/theme_changer.dart';
import 'package:cake_wallet/themes.dart';
import 'package:cake_wallet/src/widgets/standart_switch.dart';

class NodeListPage extends BasePage {
  final bool _isOn = true;
  NodeListPage();

  String get title => 'Nodes';

  @override
  Widget trailing(context) {
    final nodeList = Provider.of<NodeListStore>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Reset settings',
                          textAlign: TextAlign.center,
                        ),
                        content: Text(
                          'Are you sure that you want to reset settings to default?',
                          textAlign: TextAlign.center,
                        ),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')),
                          FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await nodeList.reset();
                              },
                              child: Text('Reset'))
                        ],
                      );
                    });
              },
              child: Text(
                'Reset',
                style: TextStyle(fontSize: 16.0,
                    color: _isDarkTheme ? PaletteDark.darkThemeGrey : Palette.wildDarkBlue
                ),
              )),
        ),
        Container(
            width: 28.0,
            height: 28.0,
            decoration:
                BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isDarkTheme ? PaletteDark.darkThemeViolet : Palette.purple
                ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(Icons.add, color: Palette.violet, size: 22.0),
                ButtonTheme(
                  minWidth: 28.0,
                  height: 28.0,
                  child: FlatButton(
                      shape: CircleBorder(),
                      onPressed: () async {
                        await Navigator.of(context).pushNamed(Routes.newNode);
                        nodeList.update();
                      },
                      child: Offstage()),
                )
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) _isDarkTheme = true;
    else _isDarkTheme = false;

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        resizeToAvoidBottomPadding: false,
        appBar: CupertinoNavigationBar(
          leading: leading(context),
          middle: middle(context),
          trailing: trailing(context),
          backgroundColor: _isDarkTheme ? PaletteDark.darkThemeAppBarBlack
              : Colors.white,
          border: null,
        ),
        body: SafeArea(child: body(context)));
  }

  @override
  Widget body(context) {
    final nodeList = Provider.of<NodeListStore>(context);
    final settings = Provider.of<SettingsStore>(context);

    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    Color _currentColor, _notCurrentColor;
    bool _isDarkTheme;

    if (_themeChanger.getTheme() == Themes.darkTheme) {
      _currentColor = PaletteDark.darkThemeViolet;
      _notCurrentColor = Theme.of(context).backgroundColor;
      _isDarkTheme = true;
    }
    else {
      _currentColor = Palette.purple;
      _notCurrentColor = Colors.white;
      _isDarkTheme = false;
    }

    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                color: _isDarkTheme ? Theme.of(context).backgroundColor : Palette.lightGrey2,
                child: ListTile(
                    title: Text(
                      'Auto switch node',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: _isDarkTheme ? PaletteDark.darkThemeTitle : Colors.black
                      ),
                    ),
                    trailing: StandartSwitch(
                        value: _isOn,
                        onTaped: () => null
                    )
                    ),
              ))
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(child: Observer(builder: (context) {
            return ListView.separated(
                separatorBuilder: (_, __) =>
                    Divider(
                        color: _isDarkTheme ? PaletteDark.darkThemeDarkGrey : Palette.lightGrey,
                        height: 1),
                itemCount: nodeList.nodes.length,
                itemBuilder: (BuildContext context, int index) {
                  final node = nodeList.nodes[index];

                  return Observer(builder: (_) {
                    final isCurrent = settings.node == null
                        ? false
                        : node.id == settings.node.id;

                    final content = Container(
                        color: isCurrent ? _currentColor : _notCurrentColor,
                        child: ListTile(
                          title: Text(
                            node.uri,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: _isDarkTheme ? PaletteDark.darkThemeTitle : Colors.black
                            ),
                          ),
                          trailing: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCurrent ? Palette.green : Palette.red),
                          ),
                          onTap: () async {
                            if (!isCurrent) {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                        'Are you sure to change current node to '
                                        '${node.uri}?',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel')),
                                        FlatButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await settings.setCurrentNode(
                                                  node: node);
                                            },
                                            child: const Text('Change')),
                                      ],
                                    );
                                  });
                            }
                          },
                        ));

                    return isCurrent
                        ? content
                        : Dismissible(
                            key: Key(node.id.toString()),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Remove node',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: const Text(
                                        'Are you sure that you want to remove selected node?',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancel')),
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Remove')),
                                      ],
                                    );
                                  });
                            },
                            onDismissed: (direction) async {
                              await nodeList.remove(node: node);
                              // setState(() {
                              //   _nodes.remove(_nodes.keys.elementAt(index));
                              // });
                            },
                            direction: DismissDirection.endToStart,
                            background: Container(
                                padding: EdgeInsets.only(right: 10.0),
                                alignment: AlignmentDirectional.centerEnd,
                                color: Palette.red,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.white,
                                    ),
                                    const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )),
                            child: content);
                  });
                });
          }))
        ],
      ),
    );
  }
}
