import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/text.dart';

class KAlertDialog extends StatelessWidget {
  const KAlertDialog({
    this.title,
    this.content,
    this.actions,
    this.submitText,
    this.submitAction,
    Key? key,
  }) : super(key: key);

  final Widget? title, content, submitText;
  final List<Widget>? actions;
  final Function()? submitAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(color: ContstantTexts.kColorCancelText, fontWeight: FontWeight.normal)),
        ),
        TextButton(
          onPressed: submitAction,
          child: submitText ?? const Text('Yes', style: TextStyle(color: ContstantTexts.kColorDeleteText, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
