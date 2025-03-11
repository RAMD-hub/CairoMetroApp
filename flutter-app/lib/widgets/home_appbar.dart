import 'package:flutter/material.dart';

import 'custom_icon.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      floating: false,
      leading: const Padding(
        padding: EdgeInsets.only(left: 16.0),
        child: CustomIcon(icon: Icons.location_on_outlined),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CustomIcon(icon: Icons.language, color: Colors.black),
        ),
      ],
    );
  }
}
