import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/db/db_functions/customer_database/customer_database.dart';
import 'package:shop_ez/model/customer/customer_model.dart';
import 'package:shop_ez/screens/pos/widgets/custom_bottom_sheet_widget.dart';
import 'package:shop_ez/screens/pos/widgets/payment_buttons_widget.dart';
import 'package:shop_ez/screens/pos/widgets/price_section_widget.dart';
import 'package:shop_ez/screens/pos/widgets/sales_table_header_widget.dart';
import 'package:shop_ez/widgets/button_widgets/material_button_widget.dart';
import 'package:shop_ez/widgets/gesture_dismissible_widget/dismissible_widget.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
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

//========== TextEditing Controllers ==========
  final _customerController = TextEditingController();

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
                SaleSideWidget(
                  screenSize: _screenSize,
                  customerController: _customerController,
                ),
                kWidth20,

                //==================== Right Side ====================
                ProductSideWidget(screenSize: _screenSize)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//==================== Sale Side Widget ====================
class SaleSideWidget extends StatefulWidget {
  const SaleSideWidget({
    Key? key,
    required this.customerController,
    required Size screenSize,
  })  : _screenSize = screenSize,
        super(key: key);

//========== MediaQuery Screen Size ==========
  final Size _screenSize;

//========== TextEditing Controllers ==========
  final TextEditingController customerController;

  @override
  State<SaleSideWidget> createState() => _SaleSideWidgetState();
}

class _SaleSideWidgetState extends State<SaleSideWidget> {
  int? _customerId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget._screenSize.width / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //========== Get All Customers Search Field ==========
              Flexible(
                flex: 8,
                child: TypeAheadField(
                  debounceDuration: const Duration(milliseconds: 500),
                  hideSuggestionsOnKeyboardHide: false,
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: widget.customerController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: const Icon(Icons.clear),
                            onTap: () {
                              _customerId = null;
                              widget.customerController.clear();
                            },
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(10),
                        hintText: 'Cash Customer',
                        border: const OutlineInputBorder(),
                      )),
                  noItemsFoundBuilder: (context) => const SizedBox(
                      height: 50,
                      child: Center(child: Text('No Customer Found!'))),
                  suggestionsCallback: (pattern) async {
                    return CustomerDatabase.instance
                        .getCustomerSuggestions(pattern);
                  },
                  itemBuilder: (context, CustomerModel suggestion) {
                    return ListTile(title: Text(suggestion.customer));
                  },
                  onSuggestionSelected: (CustomerModel suggestion) {
                    widget.customerController.text = suggestion.customer;
                    _customerId = suggestion.id;
                    setState(() {});
                    log(suggestion.company);
                  },
                ),
              ),
              kWidth5,

              //========== View Customer Button ==========
              Flexible(
                flex: 1,
                child: IconButton(
                    color: kBlack,
                    onPressed: () {
                      if (_customerId != null) {
                        log('$_customerId');

                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: kTransparentColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) => customerSheet());
                      } else {
                        showSnackBar(
                            context: context,
                            content:
                                'Please select any Customer to show details!');
                      }
                    },
                    icon: const Icon(
                      Icons.visibility,
                      color: Colors.blue,
                    )),
              ),

              //========== Add Customer Button ==========
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
          const SalesTableHeaderWidget(),

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
                border: TableBorder.all(color: Colors.grey, width: 0.5),
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
          PriceSectionWidget(screenSize: widget._screenSize),

          //==================== Payment Buttons Widget ====================
          PaymentButtonsWidget(screenSize: widget._screenSize)
        ],
      ),
    );
  }

  //==================== Customer Bottom Sheet ====================
  Widget customerSheet() {
    return DismissibleWidget(
      context: context,
      child: CustomBottomSheetWidget(customerId: _customerId),
    );
  }
}

//==================== Product Side Widget ====================
class ProductSideWidget extends StatelessWidget {
  const ProductSideWidget({
    Key? key,
    required Size screenSize,
  })  : _screenSize = screenSize,
        super(key: key);

  final Size _screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}

//========== Show SnackBar ==========
void showSnackBar(
    {required BuildContext context,
    required String content,
    Color? color,
    Widget? icon}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          icon ?? const Text(''),
          kWidth5,
          Flexible(
            child: Text(
              content,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
