import 'package:app/model/auth_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:app/model/collection_model.dart';
import 'package:app/pages/add_meal.dart';
import 'package:app/pages/book.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/login_code.dart';
import 'package:app/pages/login_phone.dart';
import 'package:app/pages/profile.dart';
import 'package:app/pages/settings.dart';
import 'package:app/pages/sizes.dart';
import 'package:app/pages/tracker.dart';
import 'package:app/utils/app_theme.dart';
import 'package:app/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AuthModel authModel = AuthModel();
  CollectionModel<Product> productsModel = CollectionModel<Product>(authModel);
  CollectionModel<Meal> mealsModel = CollectionModel<Meal>(authModel);
  mealsModel.setFilters([
    WhereFilter('startTs', 'time',
        isGreaterThanOrEqualTo: getDateStartTs(DateTime.now())),
    WhereFilter('endTs', 'time',
        isLessThanOrEqualTo: getDateEndTs(DateTime.now())),
  ]);
  CollectionModel<Receipt> receiptsModel = CollectionModel<Receipt>(authModel);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: authModel),
      ChangeNotifierProvider.value(value: productsModel),
      ChangeNotifierProvider.value(value: mealsModel),
      ChangeNotifierProvider.value(value: receiptsModel),
    ],
    child: MyApp(),
  ));
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
        '/book': (BuildContext context) => BookPage(),
        '/profile': (BuildContext context) => ProfilePage(),
        '/sizes': (BuildContext context) => SizesPage(),
        '/phone': (BuildContext context) => LoginPagePhone(),
        '/code': (BuildContext context) => LoginPageCode(),
        '/tracker': (BuildContext context) => TrackerPage(),
        '/settings': (BuildContext context) => SettingsPage(),
        '/addmeal': (BuildContext context) => AddMealPage(),
      },
    );
  }
}
