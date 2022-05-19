import 'package:flutter/material.dart';
import 'package:shop_ez/core/utils/device/device.dart';

//==================== Constant Text ====================
class ContstantTexts {
  static const kColorDeleteText = Color(0xFFEF5350);
  static const kColorEditText = Color(0xFF0A99AB);
  static const kColorCancelText = Color(0xFF757575);
}

//==================== Constant TextStyles ====================
const kBoldText = TextStyle(fontWeight: FontWeight.bold);
const kText12 = TextStyle(fontSize: 12);
const kText12Bold = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
const kText16 = TextStyle(fontSize: 16);
final kText_10_12 = TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10);

//========== Custom TextStyles for Widgets ====================
const kTextSalesCard = TextStyle(fontSize: 12);
const kBoldTextSalesCard = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

//==================== Constant Texts ====================
const kTextDelete = Text('Delete',
    style: TextStyle(
        color: ContstantTexts.kColorDeleteText, fontWeight: FontWeight.bold));
const kTextCancel = Text('Cancel',
    style: TextStyle(
        color: ContstantTexts.kColorCancelText, fontWeight: FontWeight.bold));
const kTextEdit = Text('Edit',
    style: TextStyle(
        color: ContstantTexts.kColorEditText, fontWeight: FontWeight.bold));
