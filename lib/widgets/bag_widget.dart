import 'package:flutter/material.dart';

enum BagSize { Small, Large }

class Bag extends StatefulWidget {
  final BagSize bagSize;
  final int quantity;
  final EdgeInsets margin;
  final String text;

  const Bag({
    @required this.bagSize,
    this.margin,
    this.quantity,
    this.text = '',
  });

  @override
  _BagState createState() => _BagState();
}

class _BagState extends State<Bag> {
  ThemeData _theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  Widget _buildSmallBag() {
    return Column(
      children: <Widget>[
        Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/icons/bag_small.png',
                color: widget.quantity == 0
                    ? _theme.disabledColor
                    : _theme.textTheme.bodyText1.color,
                colorBlendMode: BlendMode.srcATop,
                height: 32,
                key: Key('sub_card_small_package_image'),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 1,
                ),
                child: Text(
                  widget.quantity != null ? '\u00D7\u200A${widget.quantity}' : '',
                  style: _theme.textTheme.caption.copyWith(
                    color: widget.quantity == 0
                        ? _theme.disabledColor
                        : _theme.textTheme.bodyText1.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  key: Key('small_bag_quantity_text'),
                ),
              ),
            ],
          ),
        ),
        widget.text.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(top: 2),
                child: Text(
                  '${widget.text}',
                  style: _theme.textTheme.bodyText2.copyWith(fontSize: 10),
                  key: Key('small_bag_size_text'),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildLargeBag() {
    return Column(
      children: <Widget>[
        Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/icons/bag_large.png',
                color: widget.quantity == 0
                    ? _theme.disabledColor
                    : _theme.textTheme.bodyText1.color,
                colorBlendMode: BlendMode.srcATop,
                height: 48,
                key: Key('sub_card_big_package_image'),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 1,
                ),
                child: Text(
                  widget.quantity != null ? '\u00D7\u200A${widget.quantity}' : '',
                  style: _theme.textTheme.caption.copyWith(
                    color: widget.quantity == 0
                        ? _theme.disabledColor
                        : _theme.textTheme.bodyText1.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  key: Key('big_bag_quantity_text'),
                ),
              ),
            ],
          ),
        ),
        widget.text.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(top: 2),
                child: Text(
                  '${widget.text}',
                  style: _theme.textTheme.bodyText2.copyWith(fontSize: 10),
                  key: Key('big_bag_size_text'),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bag;
    switch (widget.bagSize) {
      case BagSize.Small:
        bag = _buildSmallBag();
        break;
      case BagSize.Large:
        bag = _buildLargeBag();
        break;
      default:
        bag = Container(child: Text('broken'));
    }
    return Container(
      margin: widget.margin,
      child: bag,
    );
  }
}
