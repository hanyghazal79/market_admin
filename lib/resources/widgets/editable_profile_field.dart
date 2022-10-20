import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/widgets/custom_textfield.dart';

class EditableField extends StatefulWidget {
  final String textData;
  final TextEditingController controller;
  final String labelText;
  final bool isEditRequested;
  final bool isEditConfirmed;
  final double animatedWidth;
  final double animatedHeight;

  const EditableField(
      {Key key,
      this.textData,
      this.controller,
      this.labelText,
      this.isEditRequested,
      this.isEditConfirmed,
      this.animatedWidth,
      this.animatedHeight})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _EditableFieldState();
  }
}

class _EditableFieldState extends State<EditableField> {
  bool _isEditRequested;
  String _textData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textData = widget.textData;
    // _isEditRequested = false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getDataWidget(),
        SizedBox(height: 5),
        getEditWidget(),
        SizedBox(height: 5)
      ],
    );
  }

  getDataWidget() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text('${widget.labelText}:'),
          padding: EdgeInsets.only(top: 5, bottom: 5),
        ),
        Container(
          height: 48,
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(200, 200, 200, 100)),
          child: Row(
            children: [
              Expanded(
                child: Text(getTextData()),
              )
            ],
          ),
        )
      ],
    );
  }

  getEditWidget() {
    return new AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeOut,
      width: widget.animatedWidth,
      height: widget.animatedHeight,
      // color: Colors.green,
      child: CustomTextField(
        controller: widget.controller,
        labelText: 'New ${widget.labelText}',
      ),
    );
  }

  String getTextData() {
    String data;
    if (widget.isEditConfirmed == false) {
      setState(() {
        data = widget.textData;
      });
    } else {
      setState(() {
        data = (widget.controller.value.text != "")
            ? widget.controller.value.text
            : widget.textData;
      });
    }
    return data;
  }
}
