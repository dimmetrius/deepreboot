import 'package:flutter/material.dart';
import 'package:app/utils/AppTheme.dart';


class LoginPageCode extends StatefulWidget {
  final String title = 'Login';
  @override
  State<StatefulWidget> createState() => LoginPageCodeState();
}

class LoginPageCodeState extends State<LoginPageCode> {
  final TextEditingController _smsController = TextEditingController();

  _signInWithPhoneNumber() {
    Navigator.of(context).pushReplacementNamed('/tracker');
  }

  @override
  Widget build(BuildContext context) {
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
                    _signInWithPhoneNumber();
                  },
                  child: const Text('Login'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
