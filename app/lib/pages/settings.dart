import 'package:app/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SettingsPage extends StatefulWidget {
  final String title = 'Settings';
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer('/settings'),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                final FirebaseUser user = await _auth.currentUser();
                if (user == null) {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                _signOut();
                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return CustomScrollView(
          slivers: <Widget>[
            ///First sliver is the App Bar
            SliverAppBar(
              leading: Container(width: 0.0),
              // Allows the user to reveal the app bar if they begin scrolling back
              // up the list of items.
              floating: true,
              // Display a placeholder widget to visualize the shrinking size.
              flexibleSpace: Container(
                child: Container(
                  alignment: FractionalOffset.center,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    color: Colors.red,
                  ),
                ),
              ),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 100,
            ),
            SliverList(
              ///Use SliverChildListDelegate and provide a list
              ///of widgets if the count is limited
              ///
              ///Lazy building of list
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  /// To convert this infinite list to a list with "n" no of items,
                  /// uncomment the following line:
                  /// if (index > n) return null;
                  return Text("Sliver List item: $index");
                },

                /// Set childCount to limit no.of items
                /// childCount: 100,
              ),
            )
          ],
        );
      }),
    );
  }

  // Example code for sign out.
  void _signOut() async {
    await _auth.signOut();
  }
}
