import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LowTemperatureWidget extends StatelessWidget {
  final String zipCode;
  const LowTemperatureWidget({Key key, @required this.zipCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final day = DateTime.now().add(Duration(days: -6));
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 13, 5, 15),
          width: double.infinity,
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/card_background.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: '${DateFormat('dd').format(day)}',
                                style: _theme.textTheme.headline4.copyWith(
                                    color: _theme.colorScheme.onPrimary,
                                    letterSpacing: 0)),
                            TextSpan(
                              text: '\n${DateFormat('MMM').format(day)}',
                              style: _theme.textTheme.bodyText2.copyWith(
                                fontSize: 10,
                                letterSpacing: 0,
                                color: _theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(' - ',
                          style: _theme.textTheme.headline1.copyWith(
                            color: _theme.colorScheme.onPrimary,
                          )),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '${DateFormat('dd').format(DateTime.now())}',
                                style: _theme.textTheme.headline4.copyWith(
                                    color: _theme.colorScheme.onPrimary,
                                    letterSpacing: 0)),
                            TextSpan(
                              text:
                                  '\n${DateFormat('MMM').format(DateTime.now())}',
                              style: _theme.textTheme.bodyText2.copyWith(
                                fontSize: 10,
                                letterSpacing: 0,
                                color: _theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Text(
                      'Grass goes dormant, no water needed.',
                      style: _theme.textTheme.subtitle2.copyWith(
                          color: _theme.colorScheme.onPrimary,
                          height: 1.5,
                          letterSpacing: 0),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 2),
                          child: Text('Winter Lawn Care Tips ',
                              style: _theme.textTheme.bodyText2.copyWith(
                                  color: _theme.colorScheme.onPrimary,
                                  letterSpacing: 0,
                                  fontSize: 10)),
                        ),
                        Image.asset(
                          'assets/icons/info_transparent.png',
                          width: 12,
                          height: 12,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/icons/location_pin.png',
                          width: 16,
                          height: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2, right: 28),
                          child: Text(
                            '$zipCode',
                            style: _theme.textTheme.bodyText2.copyWith(
                                color: _theme.colorScheme.onPrimary,
                                letterSpacing: 0,
                                fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
