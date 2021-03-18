import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  const DialogTitle({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }
}

class DialogContent extends StatelessWidget {
  const DialogContent({Key key, this.content, this.actions}) : super(key: key);

  final String content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            content ?? '',
            style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.5),
          ),
          if (actions != null) const SizedBox(height: 40),
          if (actions != null) ...actions,
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class DialogCancelIcon extends StatelessWidget {
  const DialogCancelIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: GestureDetector(
        child: Image.asset(
          'assets/icons/cancel.png',
          height: 24,
          width: 24,
        ),
        onTap: Navigator.of(context).pop,
      ),
    );
  }
}
