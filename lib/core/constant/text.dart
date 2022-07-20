import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/utils/device/device.dart';

//==================== Constant Text ====================
class ContstantTexts {
  static const kColorDeleteText = Color(0xFFEF5350);
  static const kColorEditText = Color(0xFF0A99AB);
  static const kColorCancelText = Color(0xFF757575);
}

//==================== Constant TextStyles ====================
const kBoldText = TextStyle(fontWeight: FontWeight.bold);
const kTextBlack = TextStyle(color: kBlack);
const kTextBlackW700 = TextStyle(color: kBlack, fontWeight: FontWeight.w700);
const kTextBoldWhite = TextStyle(fontWeight: FontWeight.bold, color: kWhite);
const kText10 = TextStyle(fontSize: 10);
const kText12 = TextStyle(fontSize: 12);
const kText13 = TextStyle(fontSize: 13);
const kText13Bold = TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
const kText12Black = TextStyle(fontSize: 12, color: kBlack);
const kText12Lite = TextStyle(color: kTextColor, fontSize: 12);
const kText10Lite = TextStyle(color: kTextColor, fontSize: 10);
const kText12Bold = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
const kText16 = TextStyle(fontSize: 16);
final kText_10_12 = TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10);
final kText_10_12Black = TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10, color: kBlack);

//========== Custom TextStyles for Widgets ====================
const kTextNo10 = TextStyle(fontSize: 10, color: Color(0xFF616161));
const kTextNo12 = TextStyle(fontSize: 12, color: Color(0xFF616161));
const kTextSalesCard = TextStyle(fontSize: 12, color: kBlack);
const kTextBoldSalesCard = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
final kItemsTextStyle = TextStyle(fontSize: DeviceUtil.isTablet ? 10 : 8, color: kTextColor);
final kItemsTextStyleStock = TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 9, color: kTextColor);
final kItemsPriceStyle = TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10);
final kItemsPriceStyleBold = TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10, fontWeight: FontWeight.bold);
final kItemsButtontyle = TextStyle(color: kWhite, fontWeight: FontWeight.bold, fontSize: DeviceUtil.isTablet ? 12 : 11);

//==================== Constant Texts ====================
const kTextDelete = Text('Delete', style: TextStyle(color: ContstantTexts.kColorDeleteText, fontWeight: FontWeight.bold));
const kTextCancel = Text('Cancel', style: TextStyle(color: ContstantTexts.kColorCancelText, fontWeight: FontWeight.bold));
const kTextEdit = Text('Edit', style: TextStyle(color: ContstantTexts.kColorEditText, fontWeight: FontWeight.bold));

// TextStyle kTextNo12(double size) => TextStyle(fontSize: size, color: const Color(0xFF616161));
