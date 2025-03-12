import 'package:cairo_metro_flutter/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/metro_controller.dart';

class CustomAutoComplete extends StatelessWidget {
  CustomAutoComplete({super.key, required this.isStart});
  final MetroController metroController = Get.put(MetroController());
  final bool isStart;
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return metroController.searchStations(textEditingValue.text);
      },
      onSelected: (String selection) {
        if (isStart) {
          metroController.startStation.value = selection;
        } else {
          metroController.endStation.value = selection;
        }
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return CustomTextField(
          hint: 'Enter a station',
          textController: controller,
          onEditingComplete: onEditingComplete,
          focusNode: focusNode,
        );
      },
    );
  }
}
