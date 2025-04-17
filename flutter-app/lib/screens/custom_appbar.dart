import 'package:cairo_metro_flutter/constant.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, this.leading, this.actions, this.title});
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: kSecondaryTextColor),
      title: title,
      leading: leading,
      actions: actions,
    );
  }
}
