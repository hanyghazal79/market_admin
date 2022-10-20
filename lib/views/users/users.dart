import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/user.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/data_widget_template.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/users/add_new_user.dart';
import 'package:market_admin/views/users/profile.dart';
import 'package:provider/provider.dart';

class AppUsers extends StatefulWidget {
  final String type;

  const AppUsers({Key key, this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AppUsersState();
  }
}

class _AppUsersState extends State<AppUsers> {
  ViewModel _viewModel;
  Stream<QuerySnapshot> _stream;
  AppUser _selectedUser;
  bool _isLongPressed;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRefs();
  }

  initRefs() async {
    _isLongPressed = false;
    Statics.collectionReference = Statics.firestore
        .collection(Statics.usersCollection)
        .doc(widget.type)
        .collection(widget.type);
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    await _viewModel.getAllItems();
    setState(() {
      _stream = _viewModel.stream;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.type),
        actions: getActionsWidget(),
      ),
      body: (_stream == null)
          ? Container()
          : DataWidget(
              stream: _stream,
              params: Statics.userParams,
              nextRoute: Profile(
                type: widget.type,
              ),
              onLongPress: onLongPressed,
            ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNewUser(type: widget.type)));
          }),
    );
  }

  onLongPressed() {
    setState(() {
      _isLongPressed = true;
    });
  }

  List<Widget> getActionsWidget() {
    return (_isLongPressed == false)
        ? []
        : [
            IconButton(icon: Icon(Icons.delete), onPressed: confirmDeletion),
            IconButton(icon: Icon(Icons.clear), onPressed: clearActions)
          ];
  }

  void confirmDeletion() {
    Statics.showConfirmDialog(
        context: context,
        question: 'Are you sure you want to delete this user ?',
        actions: getConfirmActions());
  }

  List<Widget> getConfirmActions() {
    return [
      FlatButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
            deleteSelected();
          }),
      FlatButton(
          child: Text('No'),
          onPressed: (){
            Navigator.of(context).pop();
            clearActions();
          }
      )
    ];
  }

  void deleteSelected() async {
    await Statics.sharedPreferences.then((prefs) {
      setState(() {
        _selectedUser =
            AppUser.fromMap(json.decode(prefs.getString('appUser')));
      });
    });
    await _viewModel.deleteItem(
        documentReference: Statics.queryDocumentSnapshot.reference,
        imageUrl: _selectedUser.imageUrl);
  }

  void clearActions() {
    setState(() {
      _isLongPressed = false;
    });
  }
}
