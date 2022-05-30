import 'dart:developer';

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
}

class VatUtils {
//========== Singleton Instance ==========
  VatUtils._();
  static final VatUtils instance = VatUtils._();
  factory VatUtils() {
    return instance;
  }

//========== Model Classes ==========
  static List<VatModel> vats = [];

//========== Get Vat ==========
  Future<VatModel> getVatById({required int vatId}) async {
    if (vats.isNotEmpty) return vats.firstWhere((vat) => vat.id == vatId);
    await getVats();
    return vats.firstWhere((vat) => vat.id == vatId);
  }

  Future<void> getVats() async {
    log('Fetching Vats...');
    final VatDatabase userDB = VatDatabase.instance;
    vats = await userDB.getAllVats();
    log('Done!');
  }
}
