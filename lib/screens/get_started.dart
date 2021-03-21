import 'package:app_adopt/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  static const routeName = '/get-started';
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  String subtitle =
      'Setiap orang berhak untuk hidup bahagia. Bergabunglah bersama kami untuk menyebarkan kebahagiaan tersebut.';

  void _onPress(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: CustomBottomSheet(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 250,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: RaisedButton(
                      onPressed: () => _onPress(context),
                      color: Colors.black45,
                      child: Text(
                        'Mulai',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
