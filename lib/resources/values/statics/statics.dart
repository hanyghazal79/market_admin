import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_admin/models/drawer_navigation_item_model.dart';
import 'package:market_admin/models/subcategory.dart';
import 'package:market_admin/resources/database/firebase.dart';
import 'package:market_admin/resources/widgets/progress_dialog.dart';
import 'package:market_admin/viewmodels/category_viewmodel.dart';
import 'package:market_admin/viewmodels/subcategory_viewmodel.dart';
import 'package:market_admin/views/account/account.dart';
import 'package:market_admin/views/brands/brands.dart';
import 'package:market_admin/views/categories/categories.dart';
import 'package:market_admin/views/offers/offers.dart';
import 'package:market_admin/views/orders/orders.dart';
import 'package:market_admin/views/products/products.dart';
import 'package:market_admin/views/users/users.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Statics {
  static final String categoriesCollection = "Categories";
  static final String sellersCollection = "Sellers";
  static final String customersCollection = "Customers";
  static final String offersCollection = "Offers";
  static final String usersCollection = "Users";
  static final Map<String, dynamic> userTypes = {
    "Admins": {"single": "Admin", "plural": "Admins"},
    "Sellers": {"single": "Seller", "plural": "Sellers"},
    "Customers": {"single": "Customer", "plural": "Customers"}
  };
  // static final String subCategoriesCollection = "SUB-CATEGORIES";
  // static final String productsCollection = "PRODUCTS";

  static final String categoriesItem = "Categories";
  static final String subCategoriesItem = "SubCategories";
  static final String childSubCategoriesItem = "ChildSubCategories";
  static final String productsItem = "Products";
  static final String brandsCollection = "Brands";


  static final String category = "Category";
  static final String subCategory = "SubCategory";
  static final String product = "Product";

  static DrawerNavItem categories = new DrawerNavItem(
      title: Text("Categories"),
      child: Categories(),
      icon: Icon(Icons.category));
  static DrawerNavItem brands = new DrawerNavItem(
      title: Text("Brands"),
      child: Brands(),
      icon: Icon(Icons.category));
  static DrawerNavItem products = new DrawerNavItem(
      title: Text("Products"),
      child: Products(),
      icon: Icon(Icons.storage));
  static DrawerNavItem sellers = new DrawerNavItem(
      title: Text("Sellers"),
      child: AppUsers(
        type: Statics.userTypes['Sellers']['plural'],
      ),
      icon: Icon(Icons.store));
  static DrawerNavItem offers = new DrawerNavItem(
      title: Text("Offers"), child: Offers(), icon: Icon(Icons.local_offer));
  static DrawerNavItem orders = new DrawerNavItem(
      title: Text("Orders"),
      child: Orders(),
      icon: Icon(Icons.playlist_add_check));
  static DrawerNavItem customers = new DrawerNavItem(
      title: Text("Customers"),
      child: AppUsers(
        type: Statics.userTypes['Customers']['plural'],
      ),
      icon: Icon(Icons.people));
  static DrawerNavItem admins = new DrawerNavItem(
      title: Text("Admins"),
      child: AppUsers(
        type: Statics.userTypes['Admins']['plural'],
      ),
      icon: Icon(Icons.account_box));
  static DrawerNavItem account = new DrawerNavItem(
      title: Text("My Account"),
      child: Account(),
      icon: Icon(Icons.account_box));

  ////
  static List<DrawerNavItem> navItems = [
    categories,
    brands,
    products,
    sellers,
    offers,
    orders,
    customers,
    admins,
    account
  ];

  static String imageKey;

  ////
  static Future<File> chooseImage() async {
    File imageFile;
    ImagePicker imagePicker = new ImagePicker();
    var image = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(image.path);
    return imageFile;
  }

  static displayProgressDialog(BuildContext context) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return ProgressDialog();
        }));
  }

  static closeProgressDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<void> displayMessageDialog(
      {BuildContext context, String message}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
              "Message",
              style:
                  TextStyle(color: Colors.white, backgroundColor: Colors.blue),
            ),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: [Text(message)],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text("Close"))
            ],
          );
        });
  }

  static Future<void> displayActionsDialog(
      {BuildContext context, List<Widget> options}) async {
    return showDialog<void>(
        barrierColor: Colors.blue,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: Text('Choose an action:'),
              titleTextStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: options,
                ),
              ),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Close")),
              ]);
        });
  }


  static List<Widget> options;

  static Future<void> showConfirmDialog(
      {BuildContext context, String question, List<Widget> actions}) async {
    return showDialog<void>(
        barrierColor: Colors.blue,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: Text('Confirm:'),
              titleTextStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
              content: Text(question),
              actions: actions);
        });
  }


  static FirebaseFirestore firestore = DatabaseHelper.instance.firestore;
  static FirebaseStorage firebaseStorage =
      DatabaseHelper.instance.firebaseStorage;
  static StorageReference storageRef;

  static String firestorePath;
  static String storagePath;
  static String categoryName;
  static DocumentReference documentReference;
  static CollectionReference collectionReference;
  static final CollectionReference categoriesCollectionReference =
      firestore.collection(categoriesCollection);

  static Query query;

  static showBottomSheet({BuildContext context, List<Widget> children}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Container(
            alignment: Alignment.center,
            color: Colors.blue,
            width: MediaQuery.of(context).size.width / 2,
            height: 50,
            margin: EdgeInsets.only(bottom: 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children),
          );
        });
  }

  static List<Widget> children;
  static Widget productSpecificationsRow(
      {Widget title, Widget details, Widget action}) {
    return new Row(
      children: [title, details, action],
    );
  }

  static QueryDocumentSnapshot queryDocumentSnapshot;
  static String selectedDocumentID;
  static String currencySymbol = 'EGP';
  static Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();
  static final List<String> userParams = [
    'id',
    'name',
    'imageUrl',
    'type',
    'email',
    'phone',
    'address',
    'category'
  ];
  static String selectedItemName;
  static Map<String, dynamic> categoryMap = {};
  static Map<String, dynamic> subCategoryMap = {};
  static SubCategory selectedSubCategory;

// static File getProfileImage(){
  //   File file;
  //    imageFile().then((value) => file = value);
  //   return file;
  // }
  // static Future<File> imageFile() async {
  //
  //   final byteData = await rootBundle.load("assets/images/profile.png");
  //   final file = File('${(await getTemporaryDirectory()).path}/profile.png');
  //   await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   return file;
  //
  // }
}
