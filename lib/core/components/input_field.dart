import 'package:flutter/material.dart';

import '../constants/theme.dart';
import '../init/screen_size.dart';

class InputField extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final String hint;
  final Widget? widget;

  const InputField(
      {Key? key,
      required this.title,
      this.controller,
      required this.hint,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: titleTextStle,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 14.0),
              height: ScreenSize.screenHeight / 13,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Theme.of(context).backgroundColor,
                  ),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: false,
                      cursorColor: Colors.grey[600],
                      readOnly: widget == null ? false : true,
                      controller: controller,
                      style: subTitleTextStle,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleTextStle,
                      ),
                    ),
                  ),
                  widget ?? Container(),
                ],
              ),
            )
          ],
        ));
  }
}
