import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/models/drawer_navigation_item_model.dart';

class CustomDrawerBody extends StatelessWidget {
  final List<DrawerNavItem> items;

  const CustomDrawerBody({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return new ListTile(
            leading: items.elementAt(index).icon,
            title: items.elementAt(index).title,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => items.elementAt(index).child));
            },
          );
        });
  }
}
