import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {

  final bool isPassword;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  final TextEditingController textEditingController;

  CustomTextFormField(
      {this.label,
        this.icon,
        this.inputType,
        this.isPassword,
        this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Theme(
        data: ThemeData(
          hintColor: Colors.transparent,
        ),
        child: TextFormField(
          obscureText: isPassword,
          controller: textEditingController,
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              icon: Icon(
                icon,
                color: Colors.black38,
              ),
              labelStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black38,
                  )
          ),
          keyboardType: inputType,
        ),
      ),
    );
  }
}