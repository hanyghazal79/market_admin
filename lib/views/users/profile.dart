import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/user.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/custom_profile_image.dart';
import 'package:market_admin/resources/widgets/editable_profile_field.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String type;

  const Profile({Key key, this.type}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  ViewModel _viewModel;
  File _imageFile;
  String _imageUrl;
  TextEditingController _nameController,
      _emailController,
      _phoneController,
      _addressController,
      _categoryController;
  List<TextEditingController> _controllers = [];
  AppUser _appUser;
  bool _isEditRequested;
  bool _isEditConfirmed;
  double _animatedHeight, _animatedWidth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRefs();
  }

  initRefs() async {
    _animatedHeight = 0.0;
    _animatedWidth = 0.0;
    await Statics.sharedPreferences.then((prefs) {
      setState(() {
        _appUser = AppUser.fromMap(json.decode(prefs.getString('appUser')));
      });
    });
    _imageUrl = _appUser.imageUrl;
    _imageFile = null;
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    _isEditRequested = false;
    _isEditConfirmed = false;
    _nameController = new TextEditingController();
    _emailController = new TextEditingController();
    _phoneController = new TextEditingController();
    _addressController = new TextEditingController();
    _controllers.addAll([
      _nameController,
      _emailController,
      _phoneController,
      _addressController
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text(_appUser.name),
        actions: getActionsWidget(),
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
                        child: CustomProfileImage(
                          width: 200,
                          height: 200,
                          radius: 140,
                          imageUrl: _imageUrl,
                          imageFile: _imageFile,
                        )),
                    Visibility(
                      visible: (_isEditRequested == false) ? false : true,
                      child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          padding: EdgeInsets.only(left: 300, top: 170),
                          onPressed: () async {
                            await _viewModel.chooseImage();
                            setState(() {
                              _imageFile = _viewModel.imageFile;
                              _imageUrl = null;
                            });
                          }),
                    )
                  ],
                )),
            Padding(padding: EdgeInsets.all(16)),
            //===| Fields |===//
            Expanded(
                child: EditableField(
              textData: _appUser.name,
              controller: _nameController,
              labelText: tr('name'),
              isEditRequested: _isEditRequested,
              isEditConfirmed: _isEditConfirmed,
              animatedHeight: _animatedHeight,
              animatedWidth: _animatedWidth,
            )),
            Expanded(
                child: EditableField(
              textData: _appUser.email,
              controller: _emailController,
              labelText: tr('email'),
              isEditRequested: _isEditRequested,
              isEditConfirmed: _isEditConfirmed,
              animatedHeight: _animatedHeight,
              animatedWidth: _animatedWidth,
            )),
            Expanded(
                child: EditableField(
              textData: _appUser.phone,
              controller: _phoneController,
              labelText: tr('phone'),
              isEditRequested: _isEditRequested,
              isEditConfirmed: _isEditConfirmed,
              animatedHeight: _animatedHeight,
              animatedWidth: _animatedWidth,
            )),
            Expanded(
                child: EditableField(
              textData: _appUser.address,
              controller: _addressController,
              labelText: tr('address'),
              isEditRequested: _isEditRequested,
              isEditConfirmed: _isEditConfirmed,
              animatedHeight: _animatedHeight,
              animatedWidth: _animatedWidth,
            )),
            Visibility(
              visible: (widget.type == Statics.userTypes['Sellers']['plural'])
                  ? true
                  : false,
              child: Expanded(
                  child: EditableField(
                textData: _appUser.address,
                controller: _categoryController,
                labelText: tr('category'),
                isEditRequested: _isEditRequested,
                isEditConfirmed: _isEditConfirmed,
                animatedHeight: _animatedHeight,
                animatedWidth: _animatedWidth,
              )),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getActionsWidget() {
    return (_isEditRequested == false)
        ? [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isEditRequested = true;
                    _animatedWidth = MediaQuery.of(context).size.width;
                    _animatedHeight = 48;
                    // displayEditableFields();
                  });
                })
          ]
        : [
            IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isEditRequested = false;
                    _isEditConfirmed = false;

                    _animatedWidth = 0.0;
                    _animatedHeight = 0.0;
                  });
                }),
            IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () {

                  setReferences();
                  saveProfileChanges();

                  setState(() {
                    _isEditRequested = false;
                    _isEditConfirmed = true;

                    _animatedWidth = 0.0;
                    _animatedHeight = 0.0;
                  });
                })
          ];
  }

  void setReferences() async{
    if(_imageFile == null){
      _viewModel.deleteStoredImage(imageUrl: _appUser.imageUrl);
    }

    setState(() {
      Statics.storagePath =
          '${Statics.usersCollection}/${widget.type}/${_nameController.value.text}';

      Statics.documentReference = Statics.queryDocumentSnapshot.reference;
    });
  }

  void saveProfileChanges() async {
    await _viewModel.uploadImage(
        image: _viewModel.imageFile, parent: _nameController.value.text);
    var _user = new AppUser(
            id:
                '${_nameController.value.text.trim().toLowerCase()}${DateTime.now().millisecondsSinceEpoch}',
            type: widget.type,
            name: _nameController.value.text,
            email: _emailController.value.text,
            phone: _phoneController.value.text,
            address: _addressController.value.text,
            category: (widget.type == Statics.userTypes['Sellers']['plural'])
                ? _categoryController.value.text
                : null,
            imageUrl: _viewModel.imageUrl)
        .toMap();
    await _viewModel.updateObject(object: _user);
  }

  void displayEditableFields() {}
}
