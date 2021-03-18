import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _dateFormat = DateFormat("EEEE, MMM dd, yyyy, 'at' hh:mm a");

class DetailsHeader extends StatelessWidget {
  const DetailsHeader({
    @required this.onDeleteTap,
    @required this.date,
    this.title,
    this.iconPath,
    Key key,
  }) : super(key: key);

  final VoidCallback onDeleteTap;
  final String title;
  final DateTime date;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtons(context),
          if (title != null) _buildHeader(),
          _buildDate(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildTitle()),
          if (iconPath != null) _buildIcon(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildDate() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        _dateFormat.format(date),
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.start,
        key: Key('task_date_details'),
      ),
    );
  }

  Widget _buildIcon() {
    return Image.asset(
      iconPath,
      width: 40,
      fit: BoxFit.fill,
      key: Key('details_screen_icon'),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDeleteButton(),
        _buildCancelButton(context),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      icon: Image.asset(
        'assets/icons/delete.png',
        width: 24,
        height: 24,
        fit: BoxFit.fill,
        key: Key('delete_icon'),
      ),
      onPressed: onDeleteTap,
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        'assets/icons/cancel.png',
        width: 24,
        height: 24,
        key: Key('cancel_button'),
      ),
      onPressed: Navigator.of(context).pop,
    );
  }
}
