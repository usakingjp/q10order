import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatelessWidget {
  const ColorPickerDialog(this.color, {super.key});
  final Color color;

  @override
  Widget build(BuildContext context) {
    Color pickedColor = color;
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(15),
      content: SingleChildScrollView(
        child: HueRingPicker(
          pickerColor: color,
          onColorChanged: (v) {
            pickedColor = v;
          },
          // colorPickerWidth: 300,
          // pickerAreaHeightPercent: 0.7,
          portraitOnly: true,
          enableAlpha: false,
          // labelTypes: [ColorLabelType.hsl, ColorLabelType.hsv],
          displayThumbColor: false,
          // paletteType: PaletteType.hsl,
          pickerAreaBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
          ),
          // hexInputBar: false,
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context, pickedColor),
          child: const Text('OK'),
        ),
        OutlinedButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('キャンセル'),
        ),
      ],
    );
  }
}
