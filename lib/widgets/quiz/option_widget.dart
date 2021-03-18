import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/dialog_content_widgets.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';

class ImageOption extends StatelessWidget {
  final Option option;
  final Function onSelected;
  final bool isSpreaderOption;

  ImageOption(
    Key key, {
    @required this.option,
    @required this.onSelected,
    this.isSpreaderOption = false,
  }) : super(key: key);

  void _showBottomSheet(BuildContext context) {
    showBottomSheetDialog(
      context: context,
      title: Align(
        alignment: Alignment.topLeft,
        child: CircleAvatar(
          child: Image.network(
            option.imageUrl,
            width: 64,
            height: 64,
          ),
          radius: 32,
        ),
      ),
      child: DialogContent(content: option.tooltipLabel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        key: Key(option.label.removeNonCharsMakeLowerCaseMethod(identifier: '_option')),
        splashColor: Styleguide.color_green_2,
        focusColor: Styleguide.color_green_2,
        highlightColor: Styleguide.color_green_2,
        onTap: () {
          onSelected(option);
        },
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: SizedBox(height: 24),
                  ),
                  CachedNetworkImage(
                    placeholder: (context, url) => Image.asset(
                      isSpreaderOption
                          ? 'assets/images/spreader_type_placeholder.png'
                          : 'assets/images/grass_type_placeholder.png',
                      width: 64,
                      height: 64,
                    ),
                    // When we don't receive grassType image url we add "invalidUrl" as url
                    // in order for this widget to show image using errorWidget.
                    imageUrl: option.imageUrl ?? 'invalidUrl',
                    errorWidget: (context, url, error) => isSpreaderOption
                        ? Image.asset(
                            'assets/images/spreader_type_placeholder.png')
                        : Image.asset(
                            'assets/images/grass_type_placeholder.png'),
                    width: 64,
                    height: 64,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      option.label,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.subtitle2.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Visibility(
                visible: option.tooltipLabel != null &&
                    option.tooltipLabel.isNotEmpty,
                child: IconButton(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  onPressed: () => _showBottomSheet(context),
                  icon: Image.asset(
                    'assets/icons/info.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
