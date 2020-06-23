import 'package:app/model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  checkAuthState(AuthModel auth, BuildContext context) {
    if (auth.isAuthenticated) {
      print('home isAuthenticated');
      Navigator.of(context).pushReplacementNamed('/tracker');
    } else {
      print('home notAuthenticated');
      Navigator.of(context).pushReplacementNamed('/phone');
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
          body: Center(child: Text('deep.reboot')),
        );
      },
    );
  }
}
