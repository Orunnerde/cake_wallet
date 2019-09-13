import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';
import 'package:cake_wallet/src/screens/nodes/new_node.dart';

class NodesList extends StatefulWidget {

  final Map<String, bool> nodes;
  final String currentNode;
  final String defaultNode;

  NodesList(this.nodes, this.currentNode, this.defaultNode);

  @override
  createState() => NodeListState(nodes, currentNode);

}

class NodeListState extends State<NodesList>{

  final _backArrowImage = Image.asset('assets/images/back_arrow.png');
  Map<String, bool> _nodes;
  String _currentNode;
  bool _isOn = true;

  NodeListState(this._nodes, this._currentNode);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
        leading: ButtonTheme(
          minWidth: double.minPositive,
          child: FlatButton(
            onPressed: (){ Navigator.pop(context); },
            child: _backArrowImage
          ),
        ),
        middle: Text('Nodes', style: TextStyle(fontSize: 16.0),),
        trailing: Row(
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
                        title: Text('Reset settings',
                          textAlign: TextAlign.center,
                        ),
                        content: Text('Are you sure that you want to reset settings to default?', textAlign: TextAlign.center,),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: (){ Navigator.pop(context); },
                            child: Text('Cancel')
                          ),
                          FlatButton(
                            onPressed: (){
                              Navigator.pop(context);
                              setState(() {
                                _currentNode = widget.defaultNode;
                              });
                            },
                            child: Text('Reset')
                          )
                        ],
                      );
                    }
                  );
                },
                child: Text('Reset', style: TextStyle(fontSize: 16.0, color: Palette.wildDarkBlue),)),
            ),
            Container(
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

                        var nodeAddress = await Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => NewNode()));
                        if (nodeAddress != null){
                          setState(() {

                            if (_nodes == null) _nodes = new Map();
                            _nodes[nodeAddress] = false;

                          });
                        }

                      },
                      child: Offstage()
                    ),
                  )
                ],
              )
            ),
          ],
        ),
        backgroundColor: Colors.white,
        border: null,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            top: 20.0,
            bottom: 20.0
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Palette.lightGrey2,
                      child: ListTile(
                        title: Text('Auto switch node', style: TextStyle(fontSize: 16.0),),
                        trailing: GestureDetector(
                          onTap: (){ setState(() {
                            _isOn = !_isOn;
                          }); },
                          child: AnimatedContainer(
                            padding: EdgeInsets.only(
                              left: 4.0,
                              right: 4.0
                            ),
                            alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
                            duration: Duration(milliseconds: 250),
                            width: 55.0,
                            height: 33.0,
                            decoration: BoxDecoration(
                              color: Palette.switchBackground,
                              border: Border.all(color: Palette.switchBorder),
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                            ),
                            child: Container(
                              width: 25.0,
                              height: 25.0,
                              decoration: BoxDecoration(
                                color: _isOn ? Palette.cakeGreen : Palette.wildDarkBlue,
                                borderRadius: BorderRadius.all(Radius.circular(8.0))
                              ),
                              child: Icon(_isOn ? Icons.check : Icons.close, color: Colors.white, size: 16.0,),
                            ),
                          ),
                        )
                      ),
                    )
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _nodes == null ? 0 : _nodes.length,
                  itemBuilder: (BuildContext context, int index){
                    return Dismissible(
                      key: Key(_nodes.keys.elementAt(index)),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Remove node',
                                textAlign: TextAlign.center,
                              ),
                              content: Text('Are you sure that you want to remove selected node?', textAlign: TextAlign.center,),
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
                      onDismissed: (direction){
                        setState(() {
                          _nodes.remove(_nodes.keys.elementAt(index));
                        });
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: EdgeInsets.only(
                          right: 10.0
                        ),
                        alignment: AlignmentDirectional.centerEnd,
                        color: Palette.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(CupertinoIcons.delete, color: Colors.white,),
                            Text('Delete', style: TextStyle(color: Colors.white),)
                          ],
                        )
                      ),
                      child: Container(
                        color: (_currentNode == _nodes.keys.elementAt(index)) ? Palette.purple : Colors.white,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                _nodes.keys.elementAt(index),
                                style: TextStyle(fontSize: 16.0),
                              ),
                              trailing: Container(
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _nodes.values.elementAt(index) ? Palette.green : Palette.red
                                ),
                              ),
                              onTap: () async {
                                if (_currentNode != _nodes.keys.elementAt(index)){
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text('Are you sure to change current node to '
                                                      '${_nodes.keys.elementAt(index)}?',
                                          textAlign: TextAlign.center,
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
                                              Navigator.pop(context);
                                              setState(() {
                                                _currentNode = _nodes.keys.elementAt(index);
                                              });
                                            },
                                            child: Text('Change')
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                }
                              },
                            ),
                            Divider(
                              color: Palette.lightGrey,
                              height: 1.0,
                            )
                          ],
                        ),
                      )
                    );
                  }
                )
              )
            ],
          ),
        )
      ),
    );

  }

}