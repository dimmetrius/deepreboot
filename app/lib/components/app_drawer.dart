import 'package:app/model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer(this.currentRoute);

  final String currentRoute;

  nav(BuildContext context, String route) {
    Navigator.of(context).pop();
    if (currentRoute != route) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(
      builder: (context, auth, child) {
        return Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Icon(
                      Icons.refresh,
                      size: 40.0,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      'DEEP.REBOOT',
                      style: TextStyle(fontSize: 30.0),
                    ),
                    Text('Feel the Taste of life')
                  ],
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.book, color: Colors.black),
                    title: Text('Book'),
                    onTap: () => nav(context, '/book'),
                  ),
                  ListTile(
                    leading: Icon(Icons.track_changes, color: Colors.black),
                    title: Text('Diary'),
                    onTap: () => nav(context, '/tracker'),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.black),
                    title: Text('Profile'),
                    onTap: () => nav(context, '/profile'),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.black),
                    title: Text('Settings'),
                    onTap: () => nav(context, '/settings'),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.format_list_numbered, color: Colors.black),
                    title: Text('Sizes'),
                    onTap: () => nav(context, '/sizes'),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
