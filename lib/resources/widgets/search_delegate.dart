import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/data_widget_template.dart';
import 'package:market_admin/resources/widgets/search_suggestions_widget.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate<String>{

  List<String> _data = [];
  List<String> _history = [];
  DatabaseHelper _helper;
  Stream<QuerySnapshot> _stream;
  Search(){
    prepareData();
  }
  prepareData()async{
    Statics.query =
        Statics.firestore.collection(Statics.categoriesCollection).where('name', isGreaterThanOrEqualTo: query);
    _helper = DatabaseHelper.instance;
    _stream = _helper.getItemsByQuery(query: Statics.query);
    _stream.listen((event) {
      event.docs.forEach((element) {
        _data.add(element.data()['name']);
      });
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation,
          ),
          onPressed: (){
            Navigator.pop(context);
          })
    ;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    Statics.query =
        Statics.firestore.collection(Statics.categoriesCollection).where('name', isGreaterThanOrEqualTo: query);
    _helper = DatabaseHelper.instance;
    _stream = _helper.getItemsByQuery(query: Statics.query);
    return DataWidget(
      stream: _stream,
      params: ['id', 'name', 'imageUrls'],
    );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // final List<String> suggestions = (query.isEmpty) ?
    // _history :
    // _data.where((element) => element.startsWith(query));
    return SuggestionsWidget(
      suggestions: _data,
      query: query,
      onSelected: (String suggestion){
        query = suggestion;
        showResults(context);
      },
    );
  }

}