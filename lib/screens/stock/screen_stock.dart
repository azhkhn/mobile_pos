import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_ez/db/db_functions/item_master/item_master_database.dart';
import 'package:shop_ez/model/item_master/item_master_model.dart';
import 'package:shop_ez/screens/stock/widgets/stock_table_header.dart';

import '../../core/utils/device/device.dart';
import '../../core/utils/text/converters.dart';
import '../../widgets/app_bar/app_bar_widget.dart';

class ScreenStock extends StatelessWidget {
  const ScreenStock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        return true;
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: 'Stock',
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              //==================== Table Header ====================
              const StockTableHeader(),

              SingleChildScrollView(
                child: FutureBuilder(
                  future: ItemMasterDatabase.instance.getAllItems(),
                  builder:
                      (ctx, AsyncSnapshot<List<ItemMasterModel>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.done:
                      default:
                        return Table(
                          columnWidths: const {
                            0: FractionColumnWidth(0.25),
                            1: FractionColumnWidth(0.20),
                            2: FractionColumnWidth(0.20),
                            3: FractionColumnWidth(0.20),
                            4: FractionColumnWidth(0.15),
                          },
                          border:
                              TableBorder.all(color: Colors.grey, width: 0.5),
                          children: List<TableRow>.generate(
                              snapshot.data!.length, (index) {
                            final ItemMasterModel _product =
                                snapshot.data![index];

                            return TableRow(children: [
                              //========== Item Name ==========
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  _product.itemName,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: DeviceUtil.isTablet ? 11 : 9),
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 9,
                                  maxFontSize: 11,
                                  maxLines: 2,
                                ),
                              ),

                              //========== Item Category ==========
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  _product.itemCategory,
                                  softWrap: true,
                                  style: TextStyle(
                                      fontSize: DeviceUtil.isTablet ? 11 : 9),
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 9,
                                  maxFontSize: 11,
                                  maxLines: 2,
                                ),
                              ),

                              //========== Item Cost ==========
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  Converter.currency
                                      .format(num.parse(_product.itemCost)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: DeviceUtil.isTablet ? 11 : 9),
                                  minFontSize: 9,
                                  maxFontSize: 11,
                                ),
                              ),

                              //========== Item Price ==========
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  Converter.currency
                                      .format(num.parse(_product.sellingPrice)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: DeviceUtil.isTablet ? 11 : 9),
                                  minFontSize: 9,
                                  maxFontSize: 11,
                                ),
                              ),

                              //========== Item Quantity ==========
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                color: Colors.white,
                                height: 30,
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  _product.openingStock!,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: DeviceUtil.isTablet ? 11 : 9,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 9,
                                  maxFontSize: 11,
                                  maxLines: 2,
                                ),
                              ),
                            ]);
                          }),
                        );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
