import 'package:app_adopt/providers/adopt.dart';
import 'package:app_adopt/providers/user.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  static const routeName = '/history';

  Future<List> _getHistoryAdopt(userId, context) {
    final responseData =
        Provider.of<Adopt>(context, listen: false).getHistoryAdopt(userId);
    return responseData;
  }

  String _formatDate(String dateFormat) {
    var date = DateTime.parse(dateFormat).toLocal();
    return '$date';
  }

  Widget _listAdopts(List data) {
    print(data);
    return Expanded(
      child: Container(
        child: ListView.separated(
          itemBuilder: (ctx, index) => Card(
            elevation: 4,
            child: Container(
              padding: EdgeInsets.all(10),
              child: ExpandablePanel(
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Atas Nama: ',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                    Text(
                      data[index]['name'],
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                expanded: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Status: Permintaan Terkirim',
                          style: TextStyle(
                            fontFamily: 'Ubuntu',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatDate(data[index]['created_at']),
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          itemCount: data.length,
          separatorBuilder: (ctx, index) => const SizedBox(
            height: 10,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<User>(context).userId;
    print(userId);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    iconSize: 30,
                  ),
                  Center(
                    child: Text(
                      'Riwayat Permintaan Adopsi',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                future: _getHistoryAdopt(userId, context),
                builder: (ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _listAdopts(snapshot.data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
