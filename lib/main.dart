
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:market_admin/viewmodels/category_viewmodel.dart';
import 'package:market_admin/viewmodels/subcategory_viewmodel.dart';
import 'package:market_admin/viewmodels/viewmodel_template.dart';
import 'package:market_admin/views/categories/categories.dart';
import 'package:market_admin/views/home/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:market_admin/views/products/products.dart';
import 'package:market_admin/views/subcategories/subcategories.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(EasyLocalization(
    path: 'assets/language',
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ar', 'DZ'),
    ],
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryViewModel()),
        ChangeNotifierProvider(create: (context) => SubCategoryViewModel()),
        ChangeNotifierProvider(create: (context) => ViewModel())

      ],
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        EasyLocalization.of(context).delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      debugShowCheckedModeBanner: false,
      title: 'Market Admin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new Home(),
    );
  }
}
