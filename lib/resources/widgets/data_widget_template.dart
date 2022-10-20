import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/user.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataWidget extends StatefulWidget {
  final List<dynamic> list;
  final Stream<QuerySnapshot> stream;
  final List<String> params;
  final Widget nextRoute;
  final Function onTap;
  final Function onLongPress;

  const DataWidget(
      {Key key,
      this.stream,
      this.params,
      this.nextRoute,
      this.onTap,
      this.onLongPress,
      this.list})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _DataWidgetState();
  }
}

class _DataWidgetState extends State<DataWidget> {
  ViewModel _viewModel;
  List<dynamic> _imageUrls = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRefs();
  }

  initRefs() {
    _viewModel = Provider.of<ViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return (widget.list == null && widget.stream != null)
        ? new StreamBuilder(
            stream: widget.stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                Statics.displayMessageDialog(
                    context: context, message: snapshot.error.toString());
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  );
                default:
                  return new ListView.builder(
                      itemCount: snapshot.data.size,
                      itemBuilder: (context, index) {
                        //===| Getting image url list which is a critical step |===//
                        var _fieldValue = snapshot.data.docs
                            .elementAt(index)
                            .data()[widget.params.elementAt(2)];
                        if (_fieldValue is String) {
                          _imageUrls.clear();
                          _imageUrls.add(_fieldValue);
                        } else if (_fieldValue is List) {
                          _imageUrls = _fieldValue;
                        }
                        //===| |=======//
                        return new ListTile(
                            title: Text(snapshot.data.docs
                                .elementAt(index)
                                .data()[widget.params.elementAt(1)]
                                .toString()),
                            subtitle: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _imageUrls.length,
                                itemBuilder: (context, i) {
                                  return (i < _imageUrls.length)
                                      ? Image.network(_imageUrls.elementAt(i),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          fit: BoxFit.cover)
                                      : Image.network(_imageUrls.elementAt(0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          fit: BoxFit.cover);
                                },
                              ),
                            ),
                            onTap: () async {
                              setState(() {
                                Statics.queryDocumentSnapshot =
                                    snapshot.data.docs.elementAt(index);
                              });
                              setSharedData();
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => widget.nextRoute));
                              widget.onTap.call();
                            },
                            //===||===//
                            onLongPress: () async {
                              setState(() {
                                Statics.queryDocumentSnapshot =
                                    snapshot.data.docs.elementAt(index);
                              });

                              setSharedData();
                              widget.onLongPress.call();
                            });
                      });
              }
            })
        : new ListView.builder(
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(widget.list.elementAt(index)['name'].toString()),
                  subtitle: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Image.network(
                          widget.list.elementAt(index)['imageUrl'].toString(),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          fit: BoxFit.cover)));
            });
  }

  setSharedData() async {
    final SharedPreferences _sharedPrefs = await Statics.sharedPreferences;
    _sharedPrefs.clear();
    //
    final String _nameKey = Statics.queryDocumentSnapshot.data().keys.elementAt(1);
    final String _nameValue =
        Statics.queryDocumentSnapshot.data().values.elementAt(1);
    //
    _sharedPrefs.setString(_nameKey, _nameValue);

    //===| Set AppUser |===//
    if (Statics.queryDocumentSnapshot.data().keys.contains('email')) {
      AppUser _appUser = AppUser.fromDocumentSnapshot(Statics.queryDocumentSnapshot);
      _sharedPrefs.setString('appUser', json.encode(_appUser.toMap()));
    }
  }
}
