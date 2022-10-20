import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:provider/provider.dart';

class AdditiveWidget extends StatefulWidget {
  final String title;
  final Color titleColor, iconColor;
  final TextEditingController controller;
  final ViewModel viewModel;
  const AdditiveWidget({Key key, this.title, this.titleColor, this.iconColor, this.controller, this.viewModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AdditiveWidgetState();
  }
}

class _AdditiveWidgetState extends State<AdditiveWidget> {
  ViewModel _additiveViewModel;
  double _animatedHeight = 0.0;
  Icon _icon, _addPhotoIcon;
  Widget _child;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _additiveViewModel = Provider.of<ViewModel>(context, listen: false);
    _child = new Container();
    setState(() {
      _icon = Icon(Icons.add, color: widget.iconColor,);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                icon: _icon,
                onPressed: () {
                  setState(() {
                    if (_animatedHeight == 0.0) {
                      _child = TextField(
                        controller: widget.controller,
                        decoration: InputDecoration(hintText: 'name'),
                      );
                      _animatedHeight = 100.0;
                      _icon = Icon(Icons.remove, color: widget.iconColor,);
                      _addPhotoIcon = Icon(Icons.add_a_photo);
                    } else if (_animatedHeight == 100.0) {
                      _child = Container();
                      _animatedHeight = 0.0;
                      _icon = Icon(Icons.add, color: widget.iconColor,);
                      _addPhotoIcon = null;
                    }
                  });
                }),
            Text('${widget.title}', style: TextStyle(color: widget.titleColor),),
            Expanded(child: Container())
          ],
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: MediaQuery.of(context).size.width,
          height: _animatedHeight,
          child: Container(
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                border: (_animatedHeight == 100) ? Border.all(
                    width: 1.0, style: BorderStyle.solid, color: Colors.blue):null),
            child: Row(
              children: [
                Expanded(child: _child),
                Expanded(
                    child: InkWell(
                  child: (widget.viewModel.imageWidgetMap['childSubCategory'] ==
                          null)
                      ? _addPhotoIcon
                      : widget.viewModel.imageWidgetMap['childSubCategory'],
                  onTap: () async {
                    setState(() {
                      Statics.imageKey = "childSubCategory";
                    });
                    await widget.viewModel.chooseImage();
                    setState(() {});
                  },
                ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
