import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/drhan/AndroidStudioProjects/market_admin/lib/resources/values/statics/statics.dart';
import 'file:///C:/Users/drhan/AndroidStudioProjects/market_admin/lib/resources/enums/ui_events_enum.dart';
import 'file:///C:/Users/drhan/AndroidStudioProjects/market_admin/lib/models/category.dart';
import 'package:market_admin/viewmodels/category_viewmodel.dart';
import 'package:market_admin/views/categories/add_new_category.dart';
import 'package:provider/provider.dart';

class AddNewItem extends StatefulWidget {
  final Widget destiny;

  const AddNewItem({Key key, this.destiny}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AddNewItemState();
  }
}

class _AddNewItemState extends State<AddNewItem> {

  @override
  Widget build(BuildContext context) {
    return widget.destiny;
  }
}
