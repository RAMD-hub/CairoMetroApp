import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeCalculate {
  String time(BuildContext context, int pathNumber) {
    if (pathNumber * 3 / 60 >= 1) {
      return AppLocalizations.of(context)!
          .time((pathNumber * 3) ~/ 60, (pathNumber * 3) % 60);
    } else {
      if (pathNumber * 3 % 60 >= 3 && pathNumber * 3 % 60 <= 9) {
        return AppLocalizations.of(context)!.timeMINArb((pathNumber * 3) % 60);
      } else {
        return AppLocalizations.of(context)!.timeMIN((pathNumber * 3) % 60);
      }
    }
  }
}
