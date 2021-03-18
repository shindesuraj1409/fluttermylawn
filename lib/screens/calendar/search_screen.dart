import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildTextField(context)),
              _buildCancelButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    final text = ModalRoute.of(context)?.settings?.arguments as String;
    final controller = TextEditingController(text: text ?? '');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        autofocus: true,
        onFieldSubmitted: (value) => Navigator.of(context).pop(value),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'Task, product name, note',
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Image.asset(
              'assets/icons/search.png',
              width: 14,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return FlatButton(
      onPressed: Navigator.of(context).pop,
      child: Text(
        'CANCEL',
        style: TextStyle(
          color: Styleguide.color_green_4,
          fontSize: 14,
        ),
      ),
    );
  }
}
