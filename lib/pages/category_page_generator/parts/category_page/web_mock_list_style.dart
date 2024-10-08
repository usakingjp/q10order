import 'package:flutter/material.dart';

class WebMockListStyle extends StatelessWidget {
  const WebMockListStyle(
      {super.key,
      required this.dispImage,
      required this.dispTitle,
      required this.dispPromotion,
      required this.dispPrice,
      required this.accentColor,
      required this.subColor,
      required this.titleLength,
      required this.sampleWidth});

  final ValueNotifier<bool> dispImage;
  final ValueNotifier<bool> dispTitle;
  final ValueNotifier<bool> dispPromotion;
  final ValueNotifier<bool> dispPrice;
  final ValueNotifier<Color> accentColor;
  final ValueNotifier<Color> subColor;
  final ValueNotifier<int> titleLength;
  final ValueNotifier<int> sampleWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: sampleWidth.value / 1,
      padding: EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: subColor.value))),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (dispImage.value)
                ? Container(
                    width: sampleWidth.value / 6,
                    height: sampleWidth.value / 6,
                    margin: EdgeInsets.only(right: 10),
                    color: Colors.grey,
                  )
                : Container(),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (dispTitle.value)
                          ? Container(
                              width: sampleWidth.value -
                                  (sampleWidth.value / 6 + 40),
                              child: Text([
                                for (int i = 0; i < titleLength.value; i++) 'Ｓ'
                              ].join('')),
                            )
                          : Container(),
                      (dispPromotion.value)
                          ? Text(
                              'promotionpromotion',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          : Container(),
                    ],
                  ),
                  (dispPrice.value)
                      ? Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '￥99,999',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: accentColor.value),
                          ))
                      : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
