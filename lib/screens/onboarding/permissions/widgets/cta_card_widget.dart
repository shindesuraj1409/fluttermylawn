import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/button_widget.dart';

class CTACard extends StatelessWidget {
  final String positiveActionText;
  final String negativeActionText;

  final Widget positiveActionWidget;
  final Widget negativeActionWidget;

  final Function onPositiveActionClicked;
  final Function onNegativeActionClicked;

  CTACard({
    this.positiveActionText,
    this.negativeActionText,
    this.positiveActionWidget,
    this.negativeActionWidget,
    @required this.onPositiveActionClicked,
    @required this.onNegativeActionClicked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      heightFactor: 0.25,
      widthFactor: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              positiveActionWidget ??
                  RaisedButton(
                    child: Text(positiveActionText ?? 'YES PLEASE'),
                    onPressed: onPositiveActionClicked,
                  ),
              negativeActionWidget ??
                  Material(
                    color: Colors.transparent,
                    child: TappableText(
                      onTap: onNegativeActionClicked,
                      child: Text(
                        negativeActionText ?? 'NOT NOW',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.button.copyWith(
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
