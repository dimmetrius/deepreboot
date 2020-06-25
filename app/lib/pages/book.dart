import 'package:app/components/app_drawer.dart';
import 'package:app/model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class BookPage extends StatelessWidget {
  checkAuthState(AuthModel auth, BuildContext context) {
    if (!auth.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthModel>(
      builder: (context, auth, child) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          checkAuthState(auth, context);
        });
        return Scaffold(
          drawer: AppDrawer('/book'),
          appBar: AppBar(
            title: Text('BooK'),
          ),
          body: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('ToDo'),
            Text('size.quarter'),
            Text('BooK')
          ],),
        ),);
      },
    );
  }
}
