import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cake_wallet/routes.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/stores/node_list/node_list_store.dart';
import 'package:cake_wallet/src/stores/settings/settings_store.dart';
import 'package:cake_wallet/src/screens/base_page.dart';

class NodeListPage extends BasePage {
  final _isOn = true;
  NodeListPage();

  String get title => 'Nodes';

  @override
  Widget trailing(context) {
    final nodeList = Provider.of<NodeListStore>(context);

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
                style: TextStyle(fontSize: 16.0, color: Palette.wildDarkBlue),
              )),
        ),
        Container(
            width: 28.0,
            height: 28.0,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Palette.purple),
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
  Widget body(context) {
    final nodeList = Provider.of<NodeListStore>(context);
    final settings = Provider.of<SettingsStore>(context);

    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                color: Palette.lightGrey2,
                child: ListTile(
                    title: Text(
                      'Auto switch node',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    trailing: GestureDetector(
                      onTap: () => null,
                      child: AnimatedContainer(
                        padding: EdgeInsets.only(left: 4.0, right: 4.0),
                        alignment: _isOn
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        duration: Duration(milliseconds: 250),
                        width: 55.0,
                        height: 33.0,
                        decoration: BoxDecoration(
                            color: Palette.switchBackground,
                            border: Border.all(color: Palette.switchBorder),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Container(
                          width: 25.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                              color: _isOn
                                  ? Palette.cakeGreen
                                  : Palette.wildDarkBlue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Icon(
                            _isOn ? Icons.check : Icons.close,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      ),
                    )),
              ))
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(child: Observer(builder: (context) {
            return ListView.separated(
                separatorBuilder: (_, __) =>
                    Divider(color: Palette.lightGrey, height: 1),
                itemCount: nodeList.nodes.length,
                itemBuilder: (BuildContext context, int index) {
                  final node = nodeList.nodes[index];

                  return Observer(builder: (_) {
                    final isCurrent = node.id == settings.node.id;
                    final content = Container(
                        color: isCurrent ? Palette.purple : Colors.white,
                        child: ListTile(
                          title: Text(
                            node.uri,
                            style: TextStyle(fontSize: 16.0),
                          ),
                          trailing: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // color: _nodes.values.elementAt(index) ? Palette.green : Palette.red
                            ),
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
                                              Navigator.pop(context);
                                              await settings.setCurrent(
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
