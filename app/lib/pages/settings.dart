import 'package:app/components/app_drawer.dart';
import 'package:app/model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final String title = 'Settings';
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  checkAuthState(AuthProvider auth, BuildContext context) {
    print('settings');
    if (!auth.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          checkAuthState(auth, context);
        });
        return Scaffold(
          drawer: AppDrawer('/settings'),
          appBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              Builder(builder: (BuildContext context) {
                return FlatButton(
                  child: const Text('Sign out'),
                  textColor: Colors.red,
                  onPressed: () async {
                    auth.signOut();
                  },
                );
              })
            ],
          ),
          body: Builder(builder: (BuildContext context) {
            return Container();
          }),
        );
      },
    );
  }
}
