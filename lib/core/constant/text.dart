import 'package:flutter/cupertino.dart';
import 'package:shop_ez/core/utils/device/device.dart';

//========== Constant TextStyles ==========
const kBoldText = TextStyle(fontWeight: FontWeight.bold);
const kText12 = TextStyle(fontSize: 12);
const kText12Bold = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
const kText16 = TextStyle(fontSize: 16);
final kText_10_12 = TextStyle(fontSize: DeviceUtil.isTablet ? 12 : 10);

//========== Custom TextStyles for Widgets ==========
const kTextSalesCard = TextStyle(fontSize: 12);
const kBoldTextSalesCard = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
