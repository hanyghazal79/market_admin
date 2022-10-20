import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/resources/values/statics/statics.dart';
import 'package:market_admin/resources/widgets/data_widget_template.dart';
import 'package:market_admin/resources/widgets/search_delegate.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:provider/provider.dart';

class AddNewOffer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _AddNewOfferState();
  }

}
class _AddNewOfferState extends State<AddNewOffer> {

  TextEditingController  _searchController;
  ViewModel _viewModel;
  Stream<QuerySnapshot> _stream;
  bool _searching = false;
  bool _searched = false;
  Widget _resultWidget;
  var _offer;
  Icon _icon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRefs();
  }

  initRefs() async {
    _resultWidget = Container();
    _icon = new Icon(Icons.search);
    _searchController = new TextEditingController();
    _stream = null;
    _viewModel = Provider.of<ViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          title: (! _searching)
              ? Text('New offer')
              : TextField(
            controller: _searchController,
            onChanged: (value){
              setState(() {
                getSuggestions(value);
              });
            },

          ),
          actions: [
            IconButton(
                icon: _searching ? Icon(Icons.close) : Icon(Icons.search),
                onPressed: (){
                  // setState(() {
                  //   _searching = (_searching)?  false :  true;
                  // });
                  showSearchPage(context, Search());
                }
            ),

          ],

        ),

        body: _resultWidget
    );
  }

  void setReferences() {
    setState(() {
      // Statics.storagePath =
      // '${Statics.offersCollection}/${_dealController.value.text}';

      // Statics.documentReference = Statics.firestore
      //     .collection(Statics.offersCollection)
      //     .doc(_dealController.value.text);
    });
  }

  void addTheData() async {
    // await _viewModel.uploadImage(
    //     image: _viewModel.imageFile, parent: _dealController.value.text);
    // _offer = new Offer(
    // ).toMap();
    // await _viewModel.addNewObject(object: _offer);
  }

  void onSearchFieldTapped() {
    setState(() {
      _icon = Icon(Icons.clear);
    });
  }

  onSearchAction() {
    if (_icon == Icon(Icons.search)) {
      setState(() {
        _icon = Icon(Icons.clear);
      });
    } else {
      setState(() {
        _searchController.clear();
        _icon = Icon(Icons.search);
      });
    }
  }

  onChanged() {
    Statics.query = Statics.firestore
        .collection(Statics.categoriesCollection)
        .where('name', isGreaterThanOrEqualTo: _searchController.value.text);
    _viewModel.getItemsByQuery();
    setState(() {
      _stream = _viewModel.stream;
    });
  }

  void getSuggestions(String entry) async{
    Statics.query = Statics.firestore.collection(Statics.productsItem)
        .where('name', isGreaterThanOrEqualTo: entry);
    await _viewModel.getItemsByQuery();
    setState(() {
      _stream = _viewModel.stream;
      _resultWidget = StreamBuilder(
        stream: _stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          return ListView.builder(
            itemCount: snapshot.data.size,
              itemBuilder: (context, index){
              return ListTile(
                title: Text(snapshot.data.docs.elementAt(index).data()['name']),
                onTap: (){
                  setState(() {
                    getResult(snapshot, index);

                  });
                },
              );
              });
          },
      );
    });
  }

  void getResult(AsyncSnapshot<QuerySnapshot> snapshot, int index) async{
    _searchController.value = snapshot.data.docs.elementAt(index).data()['name'];
    Statics.query = Statics.firestore.collection(Statics.categoriesCollection)
        .where('name', isEqualTo: _searchController.value.text);
    List<String> _params = ['id', 'name', 'imageUrls'];
    await _viewModel.getItemsByQuery();
    setState(() {
      _stream = _viewModel.stream;
    });
    _resultWidget = DataWidget(
      stream: _stream,
      params: _params,
    );
  }
//Shows Search result
  void showSearchPage(BuildContext context,
      Search searchDelegate) async {
    final String selected = await showSearch<String>(
      context: context,
      delegate: searchDelegate,
    );

    if (selected != null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Word Choice: $selected'),
        ),
      );
    }
  }

}