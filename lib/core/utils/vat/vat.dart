import 'dart:developer';

import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/db/db_functions/vat/vat_database.dart';
import 'package:shop_ez/model/vat/vat_model.dart';

class VatCalculator {
//==================== Calculate Exclusive Amount from Inclusive Amount ====================
  static num getExclusiveAmount({required String sellingPrice, required int vatRate}) {
    num _exclusiveAmount = 0;
    num percentageYouHave = vatRate + 100;

    final _inclusiveAmount = num.tryParse(sellingPrice);

    _exclusiveAmount = _inclusiveAmount! * 100 / percentageYouHave;

    // log('Product VAT == ' '${_inclusiveAmount * 15 / 115}');
    // log('Exclusive == ' '${_inclusiveAmount * 100 / 115}');
    // log('Inclusive == ' '${_inclusiveAmount * 115 / 100}');

    return _exclusiveAmount;
  }

  //==================== Get VAT Amount ====================
  static num getVatAmount({
    required String vatMethod,
    required String amount,
    required int vatRate,
  }) {
    num? itemTotalVat;
    num sellingPrice = num.parse(amount);

    if (vatMethod == 'Inclusive') {
      sellingPrice = getExclusiveAmount(sellingPrice: '$sellingPrice', vatRate: vatRate);
    }

    itemTotalVat = sellingPrice * vatRate / 100;
    log('Item VAT == $itemTotalVat');
    return Converter.amountRounder(itemTotalVat);
  }
}

class VatUtils {
//========== Singleton Instance ==========
  VatUtils._();
  static final VatUtils instance = VatUtils._();
  factory VatUtils() {
    return instance;
  }

//========== Model Classes ==========
  List<VatModel> vats = [];

//========== Get Vat ==========
  Future<VatModel> getVatById({required int vatId}) async {
    if (vats.isNotEmpty) return vats.firstWhere((vat) => vat.id == vatId);
    await getVats();
    return vats.firstWhere((vat) => vat.id == vatId);
  }

  Future<void> getVats() async {
    log('Fetching Vats from database to in-memmory');
    final VatDatabase userDB = VatDatabase.instance;
    vats = await userDB.getAllVats();
    log('Vat fetched successfully!');
  }
}
