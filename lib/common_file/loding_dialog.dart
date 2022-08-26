import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Colors/colors.dart';

void showLoadingDialog(BuildContext context,String _message){
  showDialog(
    context: context,
    builder: (context) {
      // return VerificationScreen();
      return Dialog(
        child: Wrap(
          children: [
            Container(
                margin:  EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 30, bottom: 30),
                child: Center(
                  child: Row(
                    children:  [
                      SizedBox(
                        width: 10,
                      ),
                      CircularProgressIndicator(
                        backgroundColor:intello_bg_color,
                        strokeWidth: 5,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        _message,
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                ))
          ],
          // child: VerificationScreen(),
        ),
      );
    },
  );
}