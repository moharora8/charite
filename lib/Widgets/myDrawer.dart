import '../Authentication/authenication.dart';
import '../Config/config.dart';
import '../Store/myOrders.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            accountName: Text(CharityApp.sharedPreferences
                .getString(CharityApp.userName)),
            accountEmail: Text(CharityApp.sharedPreferences
                .getString(CharityApp.userEmail)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              backgroundImage: CharityApp.sharedPreferences
                          .getString(CharityApp.authtype) ==
                      'gauth'
                  ? NetworkImage(CharityApp.sharedPreferences
                      .getString(CharityApp.userAvatarUrl))
                  : null,
              // ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.track_changes),
            title: Text('My orders'),
            onTap: () {
              Route newRoute = MaterialPageRoute(builder: (_) => MyOrders());
              Navigator.pushReplacement(context, newRoute);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              print('bh');
              CharityApp.auth.signOut().then((_) {
                Route newRoute =
                    MaterialPageRoute(builder: (_) => AuthenticScreen());
                Navigator.pushReplacement(context, newRoute);
              });
            },
          ),
        ],
      ),
    );
  }
}
