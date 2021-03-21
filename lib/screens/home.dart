import 'package:app_adopt/providers/adopt.dart';
import 'package:app_adopt/providers/user.dart';
import 'package:app_adopt/screens/detail.dart';
import 'package:app_adopt/screens/overview.dart';
import 'package:app_adopt/widgets/app_drawer.dart';
import 'package:app_adopt/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Widget _header() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(
              Icons.drag_handle,
              size: 30,
            ),
            onPressed: () {
              _drawerKey.currentState.openDrawer();
            },
          ),
          Consumer<User>(
            builder: (ctx, userData, _) => Text(
              'Welcome, ${userData.userName == null ? '' : userData.userName}',
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _banner() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Card(
          color: Colors.orange[200],
          elevation: 6,
          child: Container(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, left: 15),
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Berbagi itu indah',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Ayo berbagi kebahagiaan untuk mereka yang kurang beruntung.',
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Image.asset(
                    'assets/images/banner_img.png',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List> _getListChild(BuildContext context) {
    try {
      final responseData = Provider.of<Adopt>(context).getListChild();
      return responseData;
    } catch (e) {
      throw e;
    }
  }

  Future<List> _getListPet(BuildContext context) {
    try {
      final responseData = Provider.of<Adopt>(context).getListPet();
      return responseData;
    } catch (e) {
      throw e;
    }
  }

  Widget _listAdopt(String type, context, List data) {
    // print(data);
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Text(
              type == 'child'
                  ? 'Buat Mereka Tersenyum'
                  : 'Bawa Pulang Hewan Lucu Ini',
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Text(
              type == 'child'
                  ? 'Kamu bisa berdonasi atau mengadopsi mereka'
                  : 'Kamu bisa berdonasi atau mengadopsi hewan ini',
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 190,
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(DetailScreen.routeName,
                        arguments: data[index]['id']);
                  },
                  child: CardItem(
                    'https://demo.demangkonting.com/images/adoptions/' +
                        data[index]['image'],
                    data[index]['name'],
                    data[index]['sex'],
                  ),
                );
              },
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _categoryCard(String label, String type, String imgPath) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          OverviewScreen.routeName,
          arguments: type,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.orange[200],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imgPath == null ? SizedBox() : Image.asset(imgPath),
              SizedBox(
                height: 5,
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Ubuntu',
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _category() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _categoryCard(
            'Adopsi Anak', 'child', 'assets/images/category_child.png'),
        _categoryCard('Adopsi Hewan', 'pet', 'assets/images/category_pet.png'),
        _categoryCard('Lihat Semua', 'all', null),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _drawerKey,
        drawer: AppDrawer(),
        body: Container(
          color: Colors.white,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                _banner(),
                SizedBox(
                  height: 10,
                ),
                _category(),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: _getListChild(context),
                    builder: (ctx, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _listAdopt('child', context, snapshot.data);
                    }),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: _getListPet(context),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: Container(),
                            )
                          : _listAdopt('pet', context, snapshot.data);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
