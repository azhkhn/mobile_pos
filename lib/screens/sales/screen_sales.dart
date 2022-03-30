import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
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
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: SizedBox(
            width: _screenSize.width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Customer..'),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                kHeight20,
                Table(
                  border: TableBorder.all(),
                  children: [
                    headerRow(),
                    buildRow([
                      'Rise',
                      '34.00',
                      '3',
                      '102.00',
                      'del',
                    ]),
                    buildRow([
                      'Shavarma',
                      '90.00',
                      '1',
                      '90.00',
                      'del',
                    ]),
                    buildRow([
                      'Banana',
                      '27.00',
                      '1.5',
                      '40.50',
                      'del',
                    ]),
                    buildRow([
                      'Books',
                      '24.00',
                      '10',
                      '240.00',
                      'del',
                    ]),
                    buildRow([
                      'Books',
                      '24.00',
                      '10',
                      '240.00',
                      'del',
                    ]),
                    buildRow([
                      'Books',
                      '24.00',
                      '10',
                      '240.00',
                      'del',
                    ]),
                    buildRow([
                      'Books',
                      '24.00',
                      '10',
                      '240.00',
                      'del',
                    ]),
                    buildRow([
                      'Books',
                      '24.00',
                      '10',
                      '240.00',
                      'del',
                    ]),
                    buildRow([
                      'Books',
                      '24.00',
                      '10',
                      '240.00',
                      'del',
                    ]),
                    buildRow([
                      'Books',
                      '24.00',
                      '10',
                      '240.00',
                      'del',
                    ]),
                  ],
                ),
                kHeight10,
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
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
                                  Text(
                                    'items',
                                  ),
                                  Text(
                                    '2(2)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                  Text(
                                    'Total',
                                  ),
                                  Text(
                                    '234.5',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                  Text(
                                    'Discount',
                                  ),
                                  Text(
                                    '(0)0.00',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                  Text(
                                    'VAT',
                                  ),
                                  Text(
                                    '35.31',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.blueGrey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text('Total Payable'), Text('270.71')],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.yellow[800],
                            child: const Center(
                              child: Text(
                                'Credit Payment',
                                style: TextStyle(
                                    color: kWhite, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.green[800],
                            child: const Center(
                                child: Text(
                              'Partial Payment',
                              style: TextStyle(
                                  color: kWhite, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.red[400],
                            child: const Center(
                                child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: kWhite, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.green[300],
                            child: const Center(
                                child: Text(
                              'Full Payment',
                              style: TextStyle(
                                  color: kWhite, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
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
