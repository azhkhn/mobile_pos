import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

//========== MediaQuery Screen Size ==========
  late Size _screenSize;

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: _screenSize.width * .015,
                horizontal: _screenSize.width * .02),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              //==================== Both Sides ====================
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //==================== Left Side ====================
                  SizedBox(
                    width: _screenSize.width / 2.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 8,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: 'Cash Customer',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            kWidth5,
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                  color: kBlack,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.visibility,
                                    color: Colors.blue,
                                  )),
                            ),
                            Flexible(
                              flex: 1,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.person_add,
                                    color: Colors.blue,
                                  )),
                            ),
                          ],
                        ),

                        //==================== Table Header ====================
                        Table(
                          columnWidths: const {
                            0: FractionColumnWidth(0.30),
                            1: FractionColumnWidth(0.23),
                            2: FractionColumnWidth(0.12),
                            3: FractionColumnWidth(0.23),
                            4: FractionColumnWidth(0.12),
                          },
                          border: TableBorder.all(width: 0.5),
                          children: [
                            TableRow(children: [
                              Container(
                                color: Colors.blue,
                                height: 30,
                                child: const Center(
                                  child: Text('Product',
                                      style: TextStyle(
                                          color: kWhite,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Container(
                                color: Colors.blue,
                                height: 30,
                                child: const Center(
                                  child: Text(
                                    'Price',
                                    style: TextStyle(
                                        color: kWhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.blue,
                                height: 30,
                                child: const Center(
                                  child: Text(
                                    'Qty',
                                    style: TextStyle(
                                        color: kWhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.blue,
                                height: 30,
                                child: const Center(
                                  child: Text(
                                    'Subtotal',
                                    style: TextStyle(
                                        color: kWhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                  color: Colors.blue,
                                  height: 30,
                                  child: const Center(
                                      child: Icon(
                                    Icons.delete,
                                    size: 18,
                                    color: kWhite,
                                  )))
                            ]),
                          ],
                        ),

                        //==================== Product Items Table ====================
                        Expanded(
                          child: SingleChildScrollView(
                            child: Table(
                              columnWidths: const {
                                0: FractionColumnWidth(0.30),
                                1: FractionColumnWidth(0.23),
                                2: FractionColumnWidth(0.12),
                                3: FractionColumnWidth(0.23),
                                4: FractionColumnWidth(0.12),
                              },
                              border: TableBorder.all(
                                  color: Colors.grey, width: 0.5),
                              children: List<TableRow>.generate(
                                10,
                                (index) => TableRow(children: [
                                  Container(
                                    color: Colors.white,
                                    height: 30,
                                    child: const Center(
                                      child: Text('Apple',
                                          style: TextStyle(
                                            color: kBlack,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    height: 30,
                                    child: const Center(
                                      child: Text(
                                        '130.0',
                                        style: TextStyle(
                                          color: kBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    height: 30,
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: kBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    height: 30,
                                    child: const Center(
                                      child: Text(
                                        '130.0',
                                        style: TextStyle(
                                          color: kBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      color: Colors.white,
                                      height: 30,
                                      child: const Center(
                                          child: Icon(
                                        Icons.close,
                                        size: 18,
                                      )))
                                ]),
                              ),
                            ),
                          ),
                        ),
                        kHeight5,

                        //==================== Price Sections ====================
                        Container(
                          height: _screenSize.width / 18,
                          color: kWhite,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          AutoSizeText(
                                            'items',
                                            minFontSize: 10,
                                          ),
                                          AutoSizeText(
                                            '2(2)',
                                            minFontSize: 10,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    kWidth20,
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          AutoSizeText(
                                            'Total',
                                            minFontSize: 10,
                                          ),
                                          AutoSizeText(
                                            '234.5',
                                            minFontSize: 10,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          AutoSizeText(
                                            'Discount',
                                            minFontSize: 10,
                                          ),
                                          AutoSizeText(
                                            '(0)0.00',
                                            minFontSize: 10,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    kWidth20,
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: const [
                                          AutoSizeText(
                                            'VAT',
                                            minFontSize: 10,
                                          ),
                                          AutoSizeText(
                                            '35.31',
                                            minFontSize: 10,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        //========== Payment Field ==========
                        Column(
                          children: [
                            Container(
                              height: _screenSize.width / 25,
                              padding: const EdgeInsets.all(8),
                              color: Colors.blueGrey,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  AutoSizeText('Total Payable',
                                      minFontSize: 10,
                                      style: TextStyle(
                                          color: kWhite,
                                          fontWeight: FontWeight.bold)),
                                  AutoSizeText('270.71',
                                      minFontSize: 10,
                                      style: TextStyle(
                                          color: kWhite,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: _screenSize.width / 25,
                                    child: MaterialButton(
                                      onPressed: () {},
                                      padding: const EdgeInsets.all(5),
                                      color: Colors.yellow[800],
                                      child: const Center(
                                        child: AutoSizeText(
                                          'Credit Payment',
                                          minFontSize: 10,
                                          style: TextStyle(
                                              color: kWhite,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: _screenSize.width / 25,
                                    child: MaterialButton(
                                      onPressed: () {},
                                      padding: const EdgeInsets.all(5),
                                      color: Colors.green[800],
                                      child: const Center(
                                        child: AutoSizeText(
                                          'Partial Payment',
                                          minFontSize: 10,
                                          style: TextStyle(
                                              color: kWhite,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: _screenSize.width / 25,
                                    child: MaterialButton(
                                      onPressed: () {},
                                      padding: const EdgeInsets.all(5),
                                      color: Colors.red[400],
                                      child: const Center(
                                        child: AutoSizeText(
                                          'Cancel',
                                          minFontSize: 10,
                                          style: TextStyle(
                                              color: kWhite,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: _screenSize.width / 25,
                                    child: MaterialButton(
                                      onPressed: () {},
                                      padding: const EdgeInsets.all(5),
                                      color: Colors.green[300],
                                      child: const Center(
                                        child: AutoSizeText(
                                          'Full Payment',
                                          minFontSize: 10,
                                          style: TextStyle(
                                              color: kWhite,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  kWidth20,

                  //==================== Right Side ====================
                  SizedBox(
                    width: _screenSize.width / 1.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            hintText: 'Search product by name/code',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        //==================== Quick Filter Buttons ====================
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: CustomMaterialBtton(
                                  buttonColor: Colors.blue,
                                  onPressed: () {},
                                  buttonText: 'Categories'),
                            ),
                            kWidth5,
                            Expanded(
                              flex: 5,
                              child: CustomMaterialBtton(
                                  onPressed: () {},
                                  buttonColor: Colors.orange,
                                  buttonText: 'Sub Categories'),
                            ),
                            kWidth5,
                            Expanded(
                              flex: 3,
                              child: CustomMaterialBtton(
                                onPressed: () {},
                                buttonColor: Colors.indigo,
                                buttonText: 'Brands',
                              ),
                            ),
                            kWidth5,
                            Expanded(
                              flex: 2,
                              child: MaterialButton(
                                onPressed: () {},
                                color: Colors.blue,
                                child: const Icon(
                                  Icons.rotate_left,
                                  color: kWhite,
                                ),
                              ),
                            )
                          ],
                        ),

                        //==================== Product Listing Grid ====================
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GridView.count(
                              childAspectRatio: (1 / .75),
                              crossAxisCount: 5,
                              children: List.generate(
                                30,
                                (index) => Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        AutoSizeText(
                                          'Shavarma Grillided Chicken',
                                          textAlign: TextAlign.center,
                                          minFontSize: 8,
                                          softWrap: true,
                                          style: TextStyle(fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        AutoSizeText(
                                          'Qty: 10',
                                          minFontSize: 8,
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        AutoSizeText(
                                          '90.00',
                                          minFontSize: 8,
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

//========== Header Row Product ==========
  TableRow headerRow() {
    return const TableRow(
        decoration: BoxDecoration(color: Colors.blue),
        children: [
          SizedBox(
            height: 30,
            child: Center(
              child: Text(
                'Product',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            child: Center(
              child: Text(
                'Price',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            child: Center(
              child: Text(
                'Quantity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            child: Center(
              child: Text(
                'Subtotal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 30, child: Center(child: Icon(Icons.delete)))
        ]);
  }

//========== Row Products ==========
  TableRow buildRow(List<String> cells) => TableRow(
        children: cells
            .map((item) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text(item)),
                ))
            .toList(),
      );
}
