import 'package:app/model/auth_model.dart';
import 'package:app/model/products_model.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/login_code.dart';
import 'package:app/pages/login_phone.dart';
import 'package:app/pages/settings.dart';
import 'package:app/pages/tracker.dart';
import 'package:app/utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (context) => AuthModel()),
        ChangeNotifierProvider( create: (context) => ProductsModel()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DEEP.REBOOT',
      theme: themeData,
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => HomePage(),
        '/phone': (BuildContext context) => LoginPagePhone(),
        '/code': (BuildContext context) => LoginPageCode(),
        '/tracker': (BuildContext context) => TrackerPage(),
        '/settings': (BuildContext context) => SettingsPage(),
      },
    );
  }
}
