import 'package:flutter/material.dart';
import 'package:fluttercommerce/utils/colors.dart';

class AddSucessfully extends StatelessWidget {
  const AddSucessfully({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 62,
              width: 62,
              child: Image.asset('assets/images/success.jpg'),
            ),
            SizedBox(height: 39),
            Text(
              'Post  Created Successfully',
              style:
                  boldTextStyle(fontSize: 24, color: CustomColors.TextHeader),
            ),
            Text(
              'You can see post on your home screen',
              style: normulTextStyle(
                  fontSize: 14, color: CustomColors.TextHeaderGrey),
            ),
            SizedBox(
              height: 52,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
              child: Container(
                width: double.infinity,
                height: 46,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: CustomColors.TextWhite,
                      width: 1,
                    )),
                child: Center(
                  child: Text(
                    'BACK TO HOME',
                    style: boldTextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle normulTextStyle(
      {@required double fontSize, @required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      color: color,
    );
  }

  TextStyle boldTextStyle({@required double fontSize, @required Color color}) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      color: color,
    );
  }
}
