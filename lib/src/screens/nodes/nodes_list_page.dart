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
                style: TextStyle(fontSize: 16.0,
                    color: Theme.of(context).primaryTextTheme.subtitle.color
                ),
              )),
        ),
        Container(
            width: 28.0,
            height: 28.0,
            decoration:
                BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).selectedRowColor
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
  Widget body(context) {
    final nodeList = Provider.of<NodeListStore>(context);
    final settings = Provider.of<SettingsStore>(context);

    final currentColor = Theme.of(context).selectedRowColor;
    final notCurrentColor = Theme.of(context).backgroundColor;

    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          Expanded(child: Observer(builder: (context) {
            return ListView.separated(
                separatorBuilder: (_, __) =>
                    Divider(
                        color: Theme.of(context).dividerTheme.color,
                        height: 1),
                itemCount: nodeList.nodes.length,
                itemBuilder: (BuildContext context, int index) {
                  final node = nodeList.nodes[index];

                  return Observer(builder: (_) {
                    final isCurrent = settings.node == null
                        ? false
                        : node.id == settings.node.id;

                    final content = Container(
                        color: isCurrent ? currentColor : notCurrentColor,
                        child: ListTile(
                          title: Text(
                            node.uri,
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Theme.of(context).primaryTextTheme.title.color
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
