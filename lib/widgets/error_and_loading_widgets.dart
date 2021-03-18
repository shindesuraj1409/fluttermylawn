import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';

class LoadingContainer extends StatelessWidget {
  final String message;
  final bool onPrimaryBackground;
  LoadingContainer(
    this.message, {
    this.onPrimaryBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProgressSpinner(
          color: onPrimaryBackground
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
        ),
        message != null
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  message,
                  style: theme.textTheme.headline4.copyWith(
                    color: onPrimaryBackground
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onBackground,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String errorMessage;
  final Function retryRequest;
  final bool onPrimaryBackground;
  ErrorMessage({
    @required this.errorMessage,
    @required this.retryRequest,
    this.onPrimaryBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Text(
            '$errorMessage',
            textAlign: TextAlign.center,
            style: theme.textTheme.headline4.copyWith(
              fontWeight: FontWeight.w600,
              color: onPrimaryBackground
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onBackground,
            ),
          ),
        ),
        FlatButton(
          child: Text(
            'Retry',
            style: theme.textTheme.headline4.copyWith(
              color: onPrimaryBackground
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onBackground,
            ),
          ),
          onPressed: retryRequest,
        ),
      ],
    );
  }
}
