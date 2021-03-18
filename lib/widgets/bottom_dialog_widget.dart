import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

/// Presents a dialog, bottom aligned with the bottom of the screen.
///
/// [children]
/// [allowBackNavigation], if you want the back button to dismiss the dialog.
Future<T> showBottomSheetDialog<T>({
  @required BuildContext context,
  @required Widget child,
  Widget title,
  Widget trailing,
  bool hasDivider = false,
  bool allowBackNavigation = false,
  bool isFullScreen = false,
  Color color,
  bool hasTopPadding = true,
  Widget trailingPositioned,
}) {
  assert(child != null, 'child must not be null');

  return showModalBottomSheet<T>(
    isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    backgroundColor: color,
    isDismissible: true,
    builder: (BuildContext context) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: isFullScreen ? MediaQuery.of(context).size.height - 50 : null,
        child: Stack(
          children: <Widget>[
            Wrap(
              children: [
                Center(
                  child: Container(
                    margin: trailing != null
                        ? const EdgeInsets.only(top: 13)
                        : hasTopPadding
                            ? const EdgeInsets.only(top: 13, bottom: 10)
                            : const EdgeInsets.only(top: 13),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Styleguide.color_gray_2),
                  ),
                ),
                Container(
                  padding: hasTopPadding
                      ? const EdgeInsets.only(left: 24, right: 24, bottom: 10)
                      : const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      title ?? SizedBox(),
                      trailing ?? SizedBox(),
                    ],
                  ),
                ),
                if (hasDivider)
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Divider(
                        thickness: 1,
                        color: Styleguide.color_gray_2,
                      ),
                    ),
                  ),
                Container(
                  child: child,
                ),
              ],
            ),
            if (trailingPositioned != null) trailingPositioned,
          ],
        ),
      ),
    ),
  );
}

/// Presents a dialog, bottom aligned with the bottom of the screen.
/// This is full screen dialog by default.
///
/// [children]
/// [allowBackNavigation], if you want the back button to dismiss the dialog.
Future<T> showScrollableBottomSheetDialog<T>({
  @required BuildContext context,
  @required Widget child,
  Widget title,
  Widget trailing,
  bool hasDivider = false,
  bool allowBackNavigation = false,
  Color color,
  bool hasTopPadding = true,
  Widget trailingPositioned,
}) {
  assert(child != null, 'child must not be null');

  return showModalBottomSheet<T>(
    isScrollControlled: true,
    context: context,
    enableDrag: false,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    backgroundColor: color,
    isDismissible: true,
    builder: (BuildContext context) => Container(
      height: MediaQuery.of(context).size.height - 50,
      child: SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Center(
                    child: Container(
                      margin: trailing != null
                          ? const EdgeInsets.only(top: 13)
                          : hasTopPadding
                              ? const EdgeInsets.only(top: 13, bottom: 10)
                              : const EdgeInsets.only(top: 13),
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Styleguide.color_gray_2),
                    ),
                  ),
                  Container(
                    padding: hasTopPadding
                        ? const EdgeInsets.only(left: 24, right: 24, bottom: 10)
                        : const EdgeInsets.only(
                            left: 24,
                            right: 24,
                          ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        title ?? SizedBox(),
                        trailing ?? SizedBox(),
                      ],
                    ),
                  ),
                  if (hasDivider)
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Divider(
                          thickness: 1,
                          color: Styleguide.color_gray_2,
                        ),
                      ),
                    ),
                  Container(
                    child: child,
                  ),
                ],
              ),
              if (trailingPositioned != null) trailingPositioned,
            ],
          ),
        ),
      ),
    ),
  );
}
