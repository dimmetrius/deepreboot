import 'package:app/pages/settings.dart';
import 'package:app/pages/tracker.dart';
import 'package:app/utils/AppTheme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEEP.REBOOT',
      theme: themeData,
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => TrackerPage(),
        '/tracker': (BuildContext context) => TrackerPage(),
        '/settings': (BuildContext context) => SettingsPage(),
      },
    );
  }
}
