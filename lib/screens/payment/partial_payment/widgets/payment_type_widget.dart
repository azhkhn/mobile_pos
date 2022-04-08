import 'package:flutter/material.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/sizes.dart';
import '../../../../core/utils/text/converters.dart';
import '../../../../widgets/text_field_widgets/text_field_widgets.dart';

class PaymentTypeWidget extends StatelessWidget {
  PaymentTypeWidget({
    Key? key,
  }) : super(key: key);

  //========== DropDown Items ==========
  static const List types = ['Cash', 'Card'];

  //========== MediaQuery ScreenSize ==========
  late Size _screenSize;

  //========== DropDown Controllers ==========
  // String? _payingCahController;

  //========== Text Editing Controllers ==========
  final _amountController = TextEditingController();
  final _payingNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Container(
      color: kBackgroundGrey,
      width: _screenSize.width / 1,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //========== Rate Field ==========
                Flexible(
                  flex: 1,
                  child: TextFeildWidget(
                    labelText: 'Amount *',
                    inputBorder: const OutlineInputBorder(),
                    textInputType: TextInputType.number,
                    inputFormatters: Converter.digitsOnly,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    constraints: const BoxConstraints(maxHeight: 45),
                    contentPadding: const EdgeInsets.all(10),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                ),

                kWidth20,

                //========== Type DropDown ==========
                Flexible(
                  flex: 1,
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      constraints: BoxConstraints(maxHeight: 45),
                      fillColor: kWhite,
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      label: Text('Paying By *',
                          style: TextStyle(color: klabelColorBlack)),
                      border: OutlineInputBorder(),
                    ),
                    items: types
                        .map((values) => DropdownMenuItem<String>(
                              value: values,
                              child: Text(values),
                            ))
                        .toList(),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null) {
                        return 'This field is required*';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            kHeight20,
            Flexible(
              flex: 1,
              child: TextFeildWidget(
                labelText: 'Payment Note',
                controller: _payingNoteController,
                inputBorder: const OutlineInputBorder(),
                textInputType: TextInputType.text,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required*';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
