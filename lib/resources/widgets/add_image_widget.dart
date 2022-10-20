import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/products/add_new_product.dart';
import 'package:provider/provider.dart';

class AddImageWidget extends StatefulWidget {
  // final Stream<List<Widget>> stream;
  // final ProductViewModel viewModel;
  // const AddImageWidget({Key key, this.viewModel}) : super(key: key);
  //===| Added |===//
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AddImageWidgetState();
  }
}

class _AddImageWidgetState extends State<AddImageWidget> {
  List<Widget> images = [];
  ViewModel _viewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    setState(() {
      _viewModel.imageWidgetsList.clear();
    });
    // getImages();
  }
  // getImages()async{
  //   setState(() {
  //     images.addAll(widget.viewModel.imageWidgetsList);
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return new Expanded(
        child: Column(
      children: [
        Container(
          width: 400,
          height: 200,
          child: (_viewModel.imageWidgetsList.length == 0)
              ? Image.asset('assets/images/null_image.jpg')
              : ListView.builder(
                  itemCount: (_viewModel.imageWidgetsList.length == 0) ? 0 : _viewModel.imageWidgetsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Container(
                        width: 200,
                        height: 100,
                        child: _viewModel.imageWidgetsList.elementAt(index),
                      ),
                      onLongPress: () {
                        Statics.options = [
                          InkWell(
                            child: Text('Remove image'),
                            onTap: () {
                              // widget.viewModel.removeImageAt(index: index);
                              _viewModel.imageWidgetsList.removeAt(index);
                              Navigator.of(context).pop();

                              setState(() {

                              });

                            },
                          )
                        ];
                        Statics.displayActionsDialog(
                            context: context, options: Statics.options);
                      },
                    );
                  }),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: FlatButton(
            child: Text(
              (_viewModel.imageWidgetsList.length == 0)
                  ? 'Add image'
                  : "Add another image",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () async {
              await _viewModel.chooseImage();
              setState(() {

              });
            },
          ),
        )
      ],
    ));
  }
}
