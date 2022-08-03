// import 'dart:developer';

// import 'package:mobile_number/mobile_number.dart';

// class MobileNumberUtils {
//   static Future<bool> validateMobileNumber({required String mobileNumber}) async {
//     final List<SimCard>? simCards = await MobileNumber.getSimCards;

//     if (simCards != null || simCards!.isNotEmpty) {
//       for (SimCard sim in simCards) {
//         // log('carrierName = ${sim.carrierName}');
//         // log('countryIso = ${sim.countryIso}');
//         // log('countryPhonePrefix = ${sim.countryPhonePrefix}');
//         // log('displayName = ${sim.displayName}');
//         // log('number = ${sim.number}');
//         // log('slotIndex = ${sim.slotIndex}');
//         // log('=======================================\n');
//         final String _number = sim.countryPhonePrefix! + sim.number!;
//         log('Mobile Number = $_number');
//         if (mobileNumber == _number) {
//           log('PhoneNumber verified successfully');
//           return true;
//         }
//       }
//     }

//     log('PhoneNumber verfication failed');
//     return false;
//   }
// }
