import 'package:flutter/material.dart';

class WelcomeMessageCard extends StatefulWidget {
  final int lawnSqft;
  final String grassType;

  WelcomeMessageCard({this.lawnSqft, this.grassType});

  @override
  _WelcomeMessageCardState createState() => _WelcomeMessageCardState();
}

class _WelcomeMessageCardState extends State<WelcomeMessageCard> {
  ThemeData _theme;

  final _regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  Widget _buildImage() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Image(
        image: AssetImage('assets/icons/grass_growth.png'),
        width: 40,
      ),
    );
  }

  Widget _buildHeaderText() {
    return Container(
      margin: EdgeInsets.only(bottom: 8, right: 40),
      child: Text(
        'Get ready to grow a thick, strong, green lawn!',
        style: _theme.textTheme.headline4.copyWith(
          fontWeight: FontWeight.w800,
          height: 1.11,
        ),
      ),
    );
  }

  Widget _buildTextSpans({List<TextSpan> children, TextStyle parentStyle}) {
    return RichText(
      text: TextSpan(
        text: '',
        children: children
            .map((child) => child is TextSpan
                ? TextSpan(
                    text: '${child.text} ',
                    style: parentStyle.copyWith(
                      color: child.style?.color ?? parentStyle.color,
                      fontSize: child.style?.fontSize ?? parentStyle.fontSize,
                      fontWeight:
                          child.style?.fontWeight ?? parentStyle.fontWeight,
                    ),
                  )
                : null)
            .toList(),
      ),
    );
  }

  Widget _buildBodyText() {
    return Container(
      margin: EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextSpans(
            children: [
              TextSpan(
                  text:
                      'Your plan contains everything you need to take care of your'),
              TextSpan(
                text: widget.lawnSqft
                    .toString()
                    .replaceAllMapped(_regExp, (Match m) => '${m[1]},'),
                style: TextStyle(
                  color: _theme.primaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: 'sqft'),
              if (widget.grassType != null && widget.grassType.isNotEmpty)
                TextSpan(
                  text: widget.grassType,
                  style: TextStyle(
                    color: _theme.primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              TextSpan(text: 'lawn!'),
            ],
            parentStyle: _theme.textTheme.bodyText2.copyWith(
              color: _theme.colorScheme.onBackground,
              fontSize: 14,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildImage(),
              Expanded(
                child: Column(
                  children: <Widget>[
                    _buildHeaderText(),
                    _buildBodyText(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
