import 'package:app/model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  checkAuthState(AuthProvider auth, BuildContext context) {
    if (auth.isAuthenticated) {
      print('AUTH');
      Navigator.of(context).pushReplacementNamed('/phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          checkAuthState(auth, context);
        });
        return Scaffold(body: Center(child: Text('deep.reboot')),);
      },
    );
  }
}
