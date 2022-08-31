import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';

class CustomPopupOptions extends StatelessWidget {
  const CustomPopupOptions({required this.options, Key? key}) : super(key: key);

  final List<Map<String, dynamic>> options;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: kPadding0,
      content: SizedBox(
        height: 50 * options.length.toDouble(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            options.length,
            (index) {
              final Color color = options[index]['color'];
              final String title = options[index]['title'];
              final IconData icon = options[index]['icon'];
              final Function action = options[index]['action'];
              return Expanded(
                  child: MaterialButton(
                clipBehavior: Clip.none,
                onPressed: () async {
                  Navigator.pop(context);
                  action();
                },
                color: color,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: kWhite,
                    ),
                    kWidth5,
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: kWhite),
                    ),
                  ],
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
