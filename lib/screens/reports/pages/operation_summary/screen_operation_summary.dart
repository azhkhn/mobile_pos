import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/core/utils/converters/converters.dart';
import 'package:shop_ez/core/utils/device/date_time.dart';
import 'package:shop_ez/widgets/app_bar/app_bar_widget.dart';
import 'package:shop_ez/widgets/padding_widget/item_screen_padding_widget.dart';
import 'package:shop_ez/widgets/text_field_widgets/text_field_widgets.dart';

final _fromDateController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());
final _toDateController = Provider.autoDispose<TextEditingController>((ref) => TextEditingController());

final _fromDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
final _toDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

class ScreenOperationSummary extends ConsumerWidget {
  const ScreenOperationSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Operation Summary'),
      body: SafeArea(
        child: ItemScreenPaddingWidget(
          child: Column(
            children: [
              //======================================================================
              //==================== From Date and To Date Filter Fields =============
              //======================================================================
              Row(
                children: [
                  //==================== From Date Field ====================
                  Flexible(
                    flex: 1,
                    child: TextFeildWidget(
                      hintText: 'From Date ',
                      controller: ref.read(_fromDateController),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      suffixIcon: Padding(
                        padding: kClearTextIconPadding,
                        child: InkWell(
                          child: const Icon(Icons.clear, size: 15),
                          onTap: () async {
                            ref.refresh(_fromDateController);
                            ref.read(_fromDateProvider.notifier).state = null;
                          },
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle: kText12,
                      readOnly: true,
                      isDense: true,
                      textStyle: kText12,
                      inputBorder: const OutlineInputBorder(),
                      onTap: () async {
                        final DateTime? _selectedDate = await DateTimeUtils.instance.datePicker(context, initDate: ref.read(_fromDateProvider));
                        if (_selectedDate != null) {
                          final String parseDate = Converter.dateFormat.format(_selectedDate);
                          ref.read(_fromDateController).text = parseDate.toString();
                          ref.read(_fromDateProvider.notifier).state = _selectedDate;
                        }
                      },
                    ),
                  ),

                  kWidth5,

                  //=== === === === === To Date Field === === === === ===
                  Flexible(
                    flex: 1,
                    child: TextFeildWidget(
                      hintText: 'To Date ',
                      controller: ref.read(_toDateController),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      suffixIcon: Padding(
                        padding: kClearTextIconPadding,
                        child: InkWell(
                          child: const Icon(Icons.clear, size: 15),
                          onTap: () async {
                            ref.refresh(_toDateController);
                            ref.read(_toDateProvider.notifier).state = null;
                          },
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle: kText12,
                      readOnly: true,
                      isDense: true,
                      textStyle: kText12,
                      inputBorder: const OutlineInputBorder(),
                      onTap: () async {
                        final _selectedDate = await DateTimeUtils.instance.datePicker(context, initDate: ref.read(_toDateProvider), endDate: true);
                        if (_selectedDate != null) {
                          final parseDate = Converter.dateFormat.format(_selectedDate);
                          ref.read(_toDateController).text = parseDate.toString();
                          ref.read(_toDateProvider.notifier).state = _selectedDate;
                        }
                      },
                    ),
                  )
                ],
              ),

              kHeight10,

              Card(
                elevation: 5,
                child: ListTile(
                  title: const Text('Sales', textAlign: TextAlign.center),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kHeight5,
                      Row(children: const [
                        Expanded(flex: 4, child: Text('Total Sales', textAlign: TextAlign.end, style: kText12)),
                        Expanded(flex: 1, child: Text(' = ', textAlign: TextAlign.center)),
                        Expanded(flex: 4, child: Text('18000', style: kText12)),
                      ]),
                      kHeight2,
                      Row(children: const [
                        Expanded(flex: 4, child: Text('Cash Sales', textAlign: TextAlign.end, style: kText12)),
                        Expanded(flex: 1, child: Text(' = ', textAlign: TextAlign.center)),
                        Expanded(flex: 4, child: Text('18000', style: kText12)),
                      ]),
                      kHeight2,
                      Row(children: const [
                        Expanded(flex: 4, child: Text('Bank Sales', textAlign: TextAlign.end, style: kText12)),
                        Expanded(flex: 1, child: Text(' = ', textAlign: TextAlign.center)),
                        Expanded(flex: 4, child: Text('18000', style: kText12)),
                      ]),
                      kHeight2,
                      Row(children: const [
                        Expanded(flex: 4, child: Text('Receivable', textAlign: TextAlign.end, style: kText12)),
                        Expanded(flex: 1, child: Text(' = ', textAlign: TextAlign.center)),
                        Expanded(flex: 4, child: Text('18000', style: kText12)),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
