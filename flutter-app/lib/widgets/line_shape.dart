import 'package:flutter/material.dart';

class LineShape extends StatelessWidget {
  const LineShape({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: (MediaQuery.sizeOf(context).height * 0.05).clamp(40, 1000),
      color: Colors.orange,
    );
  }
}
