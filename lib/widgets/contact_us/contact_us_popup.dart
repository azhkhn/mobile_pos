import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shop_ez/core/constant/colors.dart';
import 'package:shop_ez/core/constant/sizes.dart';
import 'package:shop_ez/core/constant/text.dart';
import 'package:shop_ez/widgets/alertdialog/custom_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPopup extends StatelessWidget {
  const ContactUsPopup({
    Key? key,
    this.headline = 'Contact Us',
  }) : super(key: key);

  final String headline;

  @override
  Widget build(BuildContext context) {
    return KAlertDialog(
        submitText: 'Okay',
        submitAction: () => Navigator.pop(context),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(headline),
            kHeight15,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Site: ',
                    style: kTextLite,
                    children: [
                      TextSpan(
                        text: 'https://www.systemsexpert.com.sa',
                        style: const TextStyle(color: kBlue),
                        recognizer: TapGestureRecognizer()..onTap = () async => await launchUrl(Uri.parse('https://www.systemsexpert.com.sa')),
                      )
                    ],
                  ),
                ),
                kHeight10,
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Email: ',
                    style: kTextLite,
                    children: [
                      TextSpan(
                        text: 'info@systemsexpert.com.sa',
                        style: const TextStyle(color: kBlue),
                        recognizer: TapGestureRecognizer()..onTap = () async => await launchUrl(Uri.parse('mailto:info@systemsexpert.com.sa')),
                      )
                    ],
                  ),
                ),
              ],
            ),
            kHeight20,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Site: ',
                    style: kTextLite,
                    children: [
                      TextSpan(
                        text: 'https://cignes.com',
                        style: const TextStyle(color: kBlue),
                        recognizer: TapGestureRecognizer()..onTap = () async => await launchUrl(Uri.parse('https://cignes.com')),
                      )
                    ],
                  ),
                ),
                kHeight10,
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Email: ',
                    style: kTextLite,
                    children: [
                      TextSpan(
                        text: 'info@cignes.com',
                        style: const TextStyle(color: kBlue),
                        recognizer: TapGestureRecognizer()..onTap = () async => await launchUrl(Uri.parse('mailto:info@cignes.com')),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
