import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cake_wallet/palette.dart';

class NodesList extends StatefulWidget {

  Map<String, bool> nodes;
  String currentNodeIndex;

  NodesList(this.nodes, this.currentNodeIndex);

  @override
  createState() => _NodeListState();

}

class _NodeListState extends State<NodesList>{

  final _backArrowImage = Image.asset('assets/images/back_arrow.png');
  bool _isOn = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
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
                onPressed: (){},
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
                      onPressed: (){},
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
                  itemCount: widget.nodes == null ? 0 : widget.nodes.length,
                  itemBuilder: (BuildContext context, int index){
                    return Dismissible(
                      key: Key(widget.nodes.keys.elementAt(index)),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                              title: const Text('Remove node',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Are you sure that you want to remove\nselected node?', textAlign: TextAlign.center,),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 3,
                                        child: ButtonTheme(
                                          minWidth: double.infinity,
                                          child: FlatButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text('Cancel',
                                              style: TextStyle(
                                                color: Palette.cakeGreen,
                                                fontSize: 16.0
                                              ),
                                            )
                                          ),
                                        ),
                                      ),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Flexible(
                                        flex: 3,
                                        child: ButtonTheme(
                                          minWidth: double.infinity,
                                          child: FlatButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: Text('Remove',
                                              style: TextStyle(
                                                color: Palette.cakeGreen,
                                                fontSize: 16.0
                                              ),
                                            ),
                                          ),
                                        )
                                      ),
                                    ],
                                  )
                                ],
                              )
                            );
                          }
                        );
                      },
                      onDismissed: (direction){
                        setState(() {
                          widget.nodes.remove(widget.nodes.keys.elementAt(index));
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
                            Icon(Icons.delete, color: Colors.white,),
                            Text('Delete', style: TextStyle(color: Colors.white),)
                          ],
                        )
                      ),
                      child: Container(
                        color: (widget.currentNodeIndex == widget.nodes.keys.elementAt(index)) ? Palette.purple : Colors.white,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                widget.nodes.keys.elementAt(index),
                                style: TextStyle(fontSize: 16.0),
                              ),
                              trailing: Container(
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.nodes.values.elementAt(index) ? Palette.green : Palette.red
                                ),
                              ),
                              onTap: (){},
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