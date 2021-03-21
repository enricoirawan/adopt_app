import 'package:app_adopt/providers/user.dart';
import 'package:app_adopt/screens/get_started.dart';
import 'package:app_adopt/screens/history.dart';
import 'package:app_adopt/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<User>(context, listen: false).userInfo;
    return SafeArea(
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Colors.orangeAccent,
                height: 150,
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 5,
                      ),
                      child: Text(
                        userInfo['full_name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Ubuntu',
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ProfileScreen.routeName,
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text(
                          'My Profile',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(HistoryScreen.routeName);
                      },
                      child: ListTile(
                        leading: Icon(Icons.history),
                        title: Text(
                          'Riwayat Permintaan',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    Consumer<User>(
                      builder: (ctx, userData, _) => InkWell(
                        onTap: () {
                          userData.logout();
                          Navigator.of(context)
                              .pushReplacementNamed(GetStartedScreen.routeName);
                        },
                        child: ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text(
                            'Keluar',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
