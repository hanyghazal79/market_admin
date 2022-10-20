import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/custom_drawer_body.dart';
import 'package:market_admin/resources/widgets/custom_drawer_header.dart';
import 'package:market_admin/resources/widgets/custom_drawer_header_text.dart';
import 'package:market_admin/resources/widgets/custom_profile_image.dart';
import 'package:market_admin/resources/widgets/custom_scaffold_drawer.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomeState();
  }
}

class _HomeState extends State<Home> {



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: CustomScaffoldDrawer(
          header: CustomDrawerHeader(
            imageWidget: CustomProfileImage(
              width: 100,
              height: 100,
              radius: 70,
              imageFile: null,
              imageUrl: null, // to be updated after user creation
            ),
            textWidget: CustomDrawerHeaderText('Sign-up/Sign-in'),
          ),
          body: CustomDrawerBody(items: Statics.navItems),
        ));
  }
}
