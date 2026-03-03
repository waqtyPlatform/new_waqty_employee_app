import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  Future<void> setColors(String main, String second) async {
    // mainColor = Color(int.parse("0xFF$main"));
    // secondColor = Color(int.parse("0xFF$second"));
  }

  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;

  static Color blueColor = Color(0xFF0088C5);
  static Color blueColorFF = Color(0xFFC6E0FF);
  static Color blueColor1FF = Color(0xFF7AD1FF);
  static Color blueColorF1 = Color(0xFFA3D1F1);
  static Color blueColorF3 = Color(0xFFA3CDF3);
  static Color blueColorD9 = Color(0xFFCED3D9);
  static Color backgroundColor = Color(0xFFF4F9FF);
  static Color greyColorEC = const Color(0xffECECEC);
  static Color greyColorF6 = const Color(0xffEBF0F6);
  static Color greenColor = const Color(0xff244E25);
  static Color blackColor14 = const Color(0xff141414);
  static Color blackColor50 = const Color(0xff505050);
  static Color blackColor8D = const Color(0xff8D8D8D);
  static Color blackColor35 = const Color(0xff353535);
  static Color whiteColorE8 = const Color(0xffE8E8E8);
  static Color greyColorC2 = const Color(0xffC2C2C2);
  static Color redColor000 = const Color(0xffDA0000);
  static Color yellowColor19 = const Color(0xffFBC119);
  static Color greyColorE0 = const Color(0xffE0E0E0);













  ///
  static Color mainColor = Color(0xFF274C77);
  static Color secondColor = Color(0xFFF5C31A);
  static Color greyColor97 = const Color(0xff979797);

  static Color blueColor72 = const Color(0xff1B1472);
  static Color blackColor17 = const Color(0xff121217);
  static Color greyColorDA = const Color(0xffD5D7DA);
  static Color greyColorBC = const Color(0xffA9A9BC);
  static Color greyColorF8 = const Color(0xffF8F8F8);
  static Color greyColor44 = const Color(0xff444444);
  static Color greyColor62 = const Color(0xff535862);
  static Color greyColorA3 = const Color(0xff8A8AA3);
  static Color greyColor67 = const Color(0xff676767);
  static Color greyColor27 = const Color(0xff181D27);
  static Color greyColor66 = const Color(0xff666666);
  static Color greyColorDB = const Color(0xffD1D1DB);
  static Color greyColor87 = const Color(0xff7F7B87);
  static Color greyColor33 = const Color(0xff333333);
  static Color greyColor82 = const Color(0xff828282);
  static Color greyColorA5 = const Color(0xffA5A5A5);
  static Color greyColorDC = const Color(0xffD8DADC);
  static Color greyColorBD = const Color(0xffBDBDBD);
  static Color blueColorEEE = const Color(0xffEEEEEE);
  static Color blueColor74 = const Color(0xffC7FF74);
  static Color blueColor6F3 = const Color(0xffC9B6F3);
  static Color blueColorDE = const Color(0xffC3FFDE);
  static Color blueColorE5 = const Color(0xff4845E5);
  static Color greenColor7C = const Color(0xff58B27C);
  static Color greenColor3E = const Color(0xff00DA3E);

  static Color blueColorE3 = const Color(0xffE2FAE3);
  static Color blueColorEE = const Color(0xffFAE2EE);
  static Color blueColorF7 = const Color(0xffD1ECF7);
  static Color blueColorA4 = const Color(0xff4553A4);

  static Color blueColor89 = const Color(0xff6C6C89);
  static Color blueColorEB = const Color(0xffFBC2EB);
  static Color blueColor1EE = const Color(0xffA6C1EE);
  static Color blueColor1ED = const Color(0xff7A8AED);
  static Color redColor = const Color(0xffFF0000);
  static Color greenColor00 = const Color(0xff41B800);
  static Color redColor00 = const Color(0xffB50200);
  static Color redColor39 = const Color(0xff9D3739);

  static Color random1() {
    List<Color> colors = [
      blueColorF3,
      blueColorF7,
      blueColorEE,
      blueColorE3,
      blueColor6F3,
      blueColorDE
    ];
    int randomNumber = Random().nextInt(colors.length);
    return colors[randomNumber];
  }

  ///

  // static Color darkBlueColor33 = const Color(0xff091133);
  // static Color darkBlueColor7C = const Color(0xff192C7C);
  // static Color darkBlueColor4B = const Color(0xff4B4B4B);
  // static Color redColor36 = const Color(0xffFE3836);
  // static Color redColor9F = const Color(0xffFFA09F);
  // static Color redColor50 = const Color(0xffCD5250);
  // static Color redColor92 = const Color(0xffFF9292);
  // static Color redColor2 = const Color(0xffFF7675);
  // static Color greyColorC7 = const Color(0xffC7C7C7);
  // static Color grey2Color = const Color(0xffEFEFF0);
  // static Color greyColorD9 = const Color(0xffD9D9D9);
  // static Color greyColorC0 = const Color(0xffC0C0C0);
  // static Color greyColorF5 = const Color(0xffF5F5F5);
  // static Color greyColorE2 = const Color(0xffE4E2E2);
  // static Color greyColorD4 = const Color(0xffD4D4D4);
}
