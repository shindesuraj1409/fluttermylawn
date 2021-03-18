import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';

class LostConnectionWidget extends StatelessWidget {
  final Function retry;

  const LostConnectionWidget({Key key, this.retry}) : super(key: key);

  BoxDecoration _radioDecoration(Color color, double radius) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      height: 296,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/blur_background.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 56.0),
            child: Image.asset(
              'assets/icons/lost_connection.png',
              width: 64,
              height: 64,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 59),
            child: Text(
              'We lost the connection with the weather service…',
              style: _theme.textTheme.headline4.copyWith(
                  color: _theme.colorScheme.onPrimary, letterSpacing: 0),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              registry<Logger>().d('TRY AGAIN');
              retry();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 52,
              decoration:
                  _radioDecoration(Styleguide.color_gray_0.withOpacity(0.1), 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TRY AGAIN',
                    style: _theme.textTheme.bodyText1.copyWith(
                        color: _theme.colorScheme.onPrimary,
                        height: 1.66,
                        letterSpacing: 0),
                  ),
                  Container(
                      width: 16.0,
                      height: 16.0,
                      margin: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: _theme.colorScheme.onPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
