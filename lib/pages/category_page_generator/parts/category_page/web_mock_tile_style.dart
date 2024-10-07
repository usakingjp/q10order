import 'package:flutter/material.dart';

class WebMockTileStyle extends StatelessWidget {
  const WebMockTileStyle(
      {super.key,
      required this.dispImage,
      required this.dispTitle,
      required this.dispPoint,
      required this.dispPrice,
      required this.rowQty,
      required this.accentColor,
      required this.subColor,
      required this.titleLength,
      required this.sampleWidth});

  final ValueNotifier<bool> dispImage;
  final ValueNotifier<bool> dispTitle;
  final ValueNotifier<bool> dispPoint;
  final ValueNotifier<bool> dispPrice;
  final ValueNotifier<int> rowQty;
  final ValueNotifier<Color> accentColor;
  final ValueNotifier<Color> subColor;
  final ValueNotifier<int> titleLength;
  final ValueNotifier<int> sampleWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: sampleWidth.value / rowQty.value,
      decoration: BoxDecoration(
          border: Border.all(color: subColor.value),
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.all((sampleWidth.value / 10) / rowQty.value / 2),
      margin: EdgeInsets.only(right: (sampleWidth.value / 10) / rowQty.value),
      child: Column(
        children: [
          (dispImage.value)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: (sampleWidth.value -
                              (rowQty.value - 1) *
                                  ((sampleWidth.value / 5) / rowQty.value)) /
                          rowQty.value,
                      height: (sampleWidth.value -
                              (rowQty.value - 1) *
                                  ((sampleWidth.value / 5) / rowQty.value)) /
                          rowQty.value,
                      color: Colors.grey,
                    ),
                  ],
                )
              : Container(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (dispTitle.value)
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          [for (int i = 0; i < titleLength.value; i++) 'Ｓ']
                              .join(''),
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : Container(),
                (dispPoint.value)
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                        color: accentColor.value,
                        child: Text('point'))
                    : Container(),
                (dispPrice.value)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                '￥99,999',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                        ],
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
