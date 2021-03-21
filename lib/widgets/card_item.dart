import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String imgUrl, name, sex;
  CardItem(this.imgUrl, this.name, this.sex);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Container(
          width: 130,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imgUrl,
                    height: 105,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 190.0 - 125.0,
                      padding: EdgeInsets.only(top: 5, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w500,
                              ),
                              softWrap: true,
                              maxLines: 2,
                            ),
                          ),
                          Text(
                            sex == 'male' ? 'Laki-Laki' : 'Perempuan',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 5, top: 5),
                      child: Text(
                        '12 thn',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
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
