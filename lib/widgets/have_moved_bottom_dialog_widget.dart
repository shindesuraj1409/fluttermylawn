import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:navigation/navigation.dart';

Future buildIHaveMovedBottomDialog(BuildContext context, ThemeData theme) {
  return showBottomSheetDialog(
    context: context,
    title: Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 6),
        child: Text(
          'The lawn address is linked to your lawn data in your area.',
          style: Theme.of(context).textTheme.headline2,
          maxLines: 3,
        ),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
              'We recommend the right products based on your location, lawn conditions and grass type.',
              style:
                  Theme.of(context).textTheme.bodyText2.copyWith(height: 1.5)),
          Container(
            padding: const EdgeInsets.only(top: 54, bottom: 16),
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                showBottomSheetDialog(
                  context: context,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 6),
                    child: Text(
                      'Just moved?',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  trailingPositioned: Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      child: Image.asset('assets/icons/cancel.png',
                          key: Key('cancel_icon'),
                          height: 24,
                          width: 24,
                          color: Styleguide.color_gray_9),
                      onTap: () => Navigator.of(context).pop(),
                      key: Key('close_icon'),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                            'When changing your lawn address, you would require to retake the lawn quiz for getting a new lawn plan.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(height: 1.5)),
                        Container(
                          padding: const EdgeInsets.only(top: 110, bottom: 32),
                          width: double.infinity,
                          child: RaisedButton(
                            key: Key('retake_quiz'),
                            child: Text('RETAKE QUIZ'),
                            onPressed: () {
                              registry<Navigation>().push('/quiz');
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text(
                'I HAVE MOVED',
                key: Key('i_have_moved'),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 32),
            width: double.infinity,
            child: OutlineButton(
              key: Key('got_it'),
              onPressed: () => Navigator.pop(context),
              child: const Text('GOT IT'),
              borderSide: BorderSide(color: theme.primaryColor),
            ),
          ),
        ],
      ),
    ),
  );
}
