import 'package:flutter/material.dart';
import 'package:my_lawn/models/pdp/local_store_locator_model.dart';

class ErrorMessage extends StatelessWidget {
  final LocalStoreState state;
  ErrorMessage(this.state);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            '${state.errorMessage}',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class NoStoreFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Image.asset(
          'assets/icons/store_not_found.png',
          width: 64,
          height: 64,
        ),
        SizedBox(height: 16),
        Text(
          'No store found!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
        )
      ],
    );
  }
}
