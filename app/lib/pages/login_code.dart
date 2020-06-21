import 'package:app/model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/AppTheme.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class LoginPageCode extends StatefulWidget {
  final String title = 'Login';
  @override
  State<StatefulWidget> createState() => LoginPageCodeState();
}

class LoginPageCodeState extends State<LoginPageCode> {
  final TextEditingController _smsController = TextEditingController();

  checkAuthState(AuthProvider auth, BuildContext context) {
    print(['login_code', auth.isAuthenticated]);
    if (auth.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed('/tracker');
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
          body: Builder(builder: (BuildContext context) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('res/icon.png'),
                      width: 100.0,
                      height: 100.0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _smsController,
                      decoration: const InputDecoration(labelText: 'code'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'code';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      color: greenPrimary,
                      onPressed: () async {
                        auth.signInWithPhoneNumber(_smsController.text);
                      },
                      child: const Text('Login'),
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
