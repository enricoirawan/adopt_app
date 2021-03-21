import 'package:app_adopt/providers/adopt.dart';
import 'package:app_adopt/screens/detail.dart';
import 'package:app_adopt/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewScreen extends StatelessWidget {
  static const routeName = '/overview';

  Future<List> _getList(type, context) async {
    var responseData;
    try {
      if (type == 'child') {
        responseData =
            Provider.of<Adopt>(context, listen: false).getListChild();
      } else if (type == 'pet') {
        responseData = Provider.of<Adopt>(context, listen: false).getListPet();
      } else {
        responseData =
            Provider.of<Adopt>(context, listen: false).getAllAdoption();
      }
      return responseData;
    } catch (e) {
      throw e;
    }
  }

  Widget _listGrid(List data, context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: GridView.builder(
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: .9,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
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
                    data[index]['sex']),
              );
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () => _getList(type, context),
          backgroundColor: Colors.white,
          color: Colors.orange[200],
          child: Container(
            child: Column(
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
                      type == 'child'
                          ? 'Adopsi Anak'
                          : type == 'pet'
                              ? 'Adopsi Hewan'
                              : 'List Adopsi',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: _getList(type, context),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : _listGrid(snapshot.data, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
