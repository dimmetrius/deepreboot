import 'package:flutter/material.dart';
import 'package:app/utils/AppTheme.dart';


class LoginPagePhone extends StatefulWidget {
  final String title = 'Login';
  @override
  State<StatefulWidget> createState() => LoginPagePhoneState();
}

class LoginPagePhoneState extends State<LoginPagePhone> {
  final TextEditingController _phoneNumberController = TextEditingController();

  _signInWithPhoneNumber() {
    Navigator.of(context).pushReplacementNamed('/code');
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
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Phone number';
                    }
                    return null;
                  },
                ),
                RaisedButton(
                  color: greenPrimary,
                  onPressed: () async {
                    _signInWithPhoneNumber();
                  },
                  child: const Text('Sign in with phone number'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
