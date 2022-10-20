import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/drhan/AndroidStudioProjects/market_admin/lib/resources/values/statics/statics.dart';

class ImagesBuilder extends StatefulWidget {
  final Stream<List<String>> stream;
  const ImagesBuilder({Key key, this.stream}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ImagesBuilderState();
  }
}

class _ImagesBuilderState extends State<ImagesBuilder> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasError) {
            Statics.displayMessageDialog(
                context: context, message: snapshot.error.toString());
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator(
                backgroundColor: Colors.blue,
              );
            default:
              return new ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data.map((imageUrl) {
                  return ListTile(

                    title: Image.network(imageUrl) ,

                    // onLongPress: () {
                    //   Statics.options = [
                    //     InkWell(
                    //       child: Text('Remove image'),
                    //       onTap: () {
                    //         snapshot.data.remove(imageUrl);
                    //         Statics.storagePath = '$imageUrl';
                    //         Statics.firebaseStorage
                    //             .getReferenceFromUrl(imageUrl)
                    //             .then((ref) => ref.delete())
                    //             .catchError((error) =>
                    //                 Statics.displayMessageDialog(
                    //                     context: context,
                    //                     message: error.toString()));
                    //       },
                    //     )
                    //   ];
                    //   Statics.displayImageOptionsDialog(
                    //       context: context, options: Statics.options);
                    // },
                  );
                }).toList(),
              );
          }
        });
  }
}
