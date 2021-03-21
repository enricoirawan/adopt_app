import 'package:app_adopt/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<User>(context, listen: false).userInfo;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'My Profile',
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                height: 500,
                child: ListView(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.orange[400],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nama',
                        labelStyle: TextStyle(fontFamily: 'Ubuntu'),
                        hintText: 'Nama',
                      ),
                      enabled: false,
                      initialValue: userInfo['full_name'],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontFamily: 'Ubuntu'),
                        hintText: 'Email',
                      ),
                      enabled: false,
                      initialValue: userInfo['email'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
