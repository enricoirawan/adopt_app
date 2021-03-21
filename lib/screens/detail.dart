import 'package:app_adopt/providers/adopt.dart';
import 'package:app_adopt/screens/adopt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail';

  Future<Map<dynamic, dynamic>> _getDetail(context, id) async {
    final response = await Provider.of<Adopt>(context).findById(id);
    // print(response);
    return response;
  }

  String _calculateAge(String userData) {
    DateTime userDate = DateTime.parse(userData);
    DateTime currentDate = DateTime.now();

    int age = currentDate.year - userDate.year;
    int ageMonth = currentDate.month - userDate.month;
    return '$age tahun $ageMonth bulan';
  }

  Widget _detailPage(context, Map<dynamic, dynamic> data) {
    print(data);
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Image.network(
              'https://demo.demangkonting.com/images/adoptions/' +
                  data['image'],
              height: 300,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        data['name'].toString(),
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Umur',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              _calculateAge(data['birthday']),
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Gender',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data['sex'],
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'Yayasan Terkait',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            data['get_orphanage']['name'],
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            'Alamat',
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                            ),
                            maxLines: 3,
                          ),
                        ),
                        Container(
                          child: Text(
                            data['get_orphanage']['address'],
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Container(
                    height: 120,
                    child: ListView(
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            data['description'].toString(),
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AdoptScreen.routeName,
                          arguments: {
                            'name': data['name'],
                            'image': data['image'],
                            'adoption_id': data['category_id'],
                            'orphanage_name': data['get_orphanage']['name'],
                            'orphanage_address': data['get_orphanage']
                                ['address'],
                          },
                        );
                      },
                      color: Colors.orange[200],
                      child: Text(
                        'Adopsi',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                      textColor: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _getDetail(context, id),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Container(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _detailPage(context, snapshot.data),
        ),
      ),
    );
  }
}
