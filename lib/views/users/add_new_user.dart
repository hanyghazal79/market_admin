import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_admin/models/user.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/enums/ui_events_enum.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/custom_profile_image.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/home/home_screen.dart';
import 'package:market_admin/views/users/users.dart';
import 'package:provider/provider.dart';

class AddNewUser extends StatefulWidget {
  final String type;
  const AddNewUser({Key key, this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AddNewUserState();
  }
}

class _AddNewUserState extends State<AddNewUser> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _addressController;
  TextEditingController _categoryController;
  DatabaseHelper _helper;
  File _imageFile;
  ViewModel _viewModel;
  var _user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRefs();
    initiateUiEvents(context);
  }

  initRefs() async {
    _nameController = new TextEditingController();
    _emailController = new TextEditingController();
    _phoneController = new TextEditingController();
    _addressController = new TextEditingController();
    _categoryController = new TextEditingController();
    _helper = DatabaseHelper.instance;
    _viewModel = Provider.of<ViewModel>(context, listen: false);
  }

  initiateUiEvents(BuildContext context) {
    _viewModel.uiEventController.stream.listen((event) async {
      if (event == UiEvents.loading) {

        Statics.displayProgressDialog(context);

      } else if (event == UiEvents.completed) {

        Statics.displayMessageDialog(
            context: context, message: _viewModel.message);
        Statics.closeProgressDialog(context);

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AppUsers(type: widget.type)));

      } else if (event == UiEvents.error) {
        await Statics.displayMessageDialog(
            context: context, message: _viewModel.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: Text('New ${Statics.userTypes[widget.type]['single']}'),
        ),
        body: Container(
          padding: EdgeInsets.only(left: 10, top: 16, right: 10, bottom: 40),
          child: ListView(
            children: [
              Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Container(
                          width: 400,
                          height: 200,
                          alignment: Alignment.center,
                          child: (_imageFile == null)
                              ? CustomProfileImage(
                                  width: 200,
                                  height: 200,
                                  radius: 140,
                                  imageFile: null,
                                )
                              : CustomProfileImage(
                                  width: 200,
                                  height: 200,
                                  radius: 140,
                                  imageFile: _imageFile,
                                )),
                      IconButton(
                          icon: Icon(Icons.add_a_photo),
                          padding: EdgeInsets.only(left: 300, top: 170),
                          onPressed: () async {
                            await _viewModel.chooseImage();
                            setState(() {
                              _imageFile = _viewModel.imageFile;
                            });
                          })
                    ],
                  )),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          controller: _nameController,
                          decoration: InputDecoration(labelText: tr('name')),
                        ),
                      ))),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          controller: _emailController,
                          decoration: InputDecoration(hintText: tr('email')),
                        ),
                      ))),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          controller: _phoneController,
                          decoration: InputDecoration(hintText: tr('phone')),
                        ),
                      ))),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          controller: _addressController,
                          decoration: InputDecoration(hintText: tr('address')),
                        ),
                      ))),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10),
                      child: Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          controller: _categoryController,
                          decoration: InputDecoration(hintText: tr('category')),
                        ),
                      ))),
              Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          setReferences();
                          addTheData();
                          // Statics.displayMessageDialog(
                          //     context: context,
                          //     message:
                          //         '${Statics.documentReference.toString()}');
                        }),
                  ))
            ],
          ),
        ));
  }

  void setReferences() {
    setState(() {
      Statics.storagePath =
          '${Statics.usersCollection}/${widget.type}/${_nameController.value.text}';

      Statics.documentReference = _helper.firestore
          .collection(Statics.usersCollection)
          .doc(widget.type)
          .collection(widget.type)
          .doc('${DateTime.now().millisecondsSinceEpoch}');

      // Statics.collectionReference = _helper.firestore
      //     .collection(Statics.usersCollection)
      //     .doc(widget.type)
      //     .collection(_emailController.value.text);
    });
  }

  void addTheData() async {
    await _viewModel.uploadImage(
        image: _viewModel.imageFile, parent: _nameController.value.text);

    _user = new AppUser(
            id: '${_nameController.value.text.trim().toLowerCase()}${DateTime.now().millisecondsSinceEpoch}',
            type: widget.type,
            name: _nameController.value.text,
            email: _emailController.value.text,
            phone: _phoneController.value.text,
            address: _addressController.value.text,
            category: (widget.type == Statics.userTypes['Sellers']['plural']) ? _categoryController.value.text : null,
            imageUrl: _viewModel.imageUrl)
        .toMap();
    await _viewModel.addNewObject(object: _user);
    // await _viewModel.addNewObjectByCollection(object: _user);
  }
}
