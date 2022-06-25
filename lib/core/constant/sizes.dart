import 'package:flutter/material.dart';

//========== Constant Sizes ==========
const SizedBox kNone = SizedBox();

const SizedBox kWidth2 = SizedBox(width: 2);
const SizedBox kWidth5 = SizedBox(width: 5);
const SizedBox kWidth10 = SizedBox(width: 10);
const SizedBox kWidth20 = SizedBox(width: 20);
const SizedBox kWidth50 = SizedBox(width: 50);

const SizedBox kHeight1 = SizedBox(height: 1);
const SizedBox kHeight2 = SizedBox(height: 2);
const SizedBox kHeight5 = SizedBox(height: 5);
const SizedBox kHeight10 = SizedBox(height: 10);
const SizedBox kHeight15 = SizedBox(height: 15);
const SizedBox kHeight20 = SizedBox(height: 20);
const SizedBox kHeight25 = SizedBox(height: 25);
const SizedBox kHeight30 = SizedBox(height: 30);
const SizedBox kHeight50 = SizedBox(height: 50);

//========== Dynamic Sizes ==========
kHeightDynamic({required double kheight}) => SizedBox(height: kheight);

//========== Edge Insets Sizes ==========
const EdgeInsets kClearTextIconPadding = EdgeInsets.only(top: 5, bottom: 5, right: 5, left: 8);
const EdgeInsets kPadding0 = EdgeInsets.all(0);
const EdgeInsets kPadding1 = EdgeInsets.all(1);
const EdgeInsets kPadding2 = EdgeInsets.all(2);
const EdgeInsets kPadding5 = EdgeInsets.all(5);
const EdgeInsets kPadding10 = EdgeInsets.all(10);
const EdgeInsets kPadding15 = EdgeInsets.all(15);
const EdgeInsets kPadding20 = EdgeInsets.all(20);
