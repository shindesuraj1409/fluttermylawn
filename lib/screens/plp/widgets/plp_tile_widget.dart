import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/widgets/product_image.dart';

class PlpTileWidget extends StatelessWidget {
  /// To show leading icon or image within the list tile
  final showLeading;

  /// To show trailing icon or image within the list tile
  final showTrailing;

  /// To show leading product image within the list tile
  /// Used in product list
  final showProduct;

  /// To align the title center or topCenter within the list tile
  final isTitleCentered;

  /// To show image from a url or local asset within the leading widget
  final isLeadingNetworkImage;

  /// To show image from a url or local asset within the trailing widget
  final isTrailingNetworkImage;

  /// To show subtitle for the list tile
  final isSubtitle;

  /// To show the tile customized as per product listing screen
  final isProductList;

  /// Title for the list tile
  final String title;

  /// Title for the list tile
  final String subtitle;

  /// Leading icon / image for the list tile
  final String leadingIcon;

  /// Trailing icon / image for the list tile
  final String trailingIcon;

  /// For the container to hold background color within the card
  final Color color;

  /// Elevation for the card that has container and list tile
  final double elevation;

  /// Padding for the container which holds the list tile
  /// Sets up the height for the widget
  final double listTileVerticalPadding;

  /// Sets up height for the container that holds leading icon / image
  final double leadingContainerVerticalPadding;

  /// Sets up width for the container that holds leading icon / image
  final double leadingContainerHorizontalPadding;

  /// Sets up height for the container that holds trailing icon / image
  final double trailingContainerVerticalPadding;

  /// Sets up width for the container that holds trailing icon / image
  final double trailingContainerHorizontalPadding;

  /// Sets up RHS padding for the container that holds trailing icon / image
  final double trailingPadding;

  /// Sets up LHS padding for the title within the list tile
  final double titleLeftPadding;

  /// Sets up top padding for the title within the list tile
  final double titleTopPadding;

  /// Sets up bottom padding for the title within the list tile
  final double titleBottomPadding;

  /// Sets up LHS padding for the subtitle within the list tile
  final double subTitleLeftPadding;

  /// Sets up top padding for the subtitle within the list tile
  final double subTitleTopPadding;

  /// Sets up bottom padding for the subtitle within the list tile
  final double subTitleBottomPadding;

  /// Sets up padding to create space between 2 cards
  final double cardVerticalPadding;

  /// Sets up horizontal padding for the cards
  final double cardHorizontalPadding;

  /// Sets up rounded edges or rectangular for the card
  final double cardBorderRadius;

  /// Sets up navigation when card is tapped
  final Function onTapMethod;

  /// Index of the items for associating the unique key to the element
  final int index;

  PlpTileWidget({
    @required this.showLeading,
    @required this.showTrailing,
    @required this.showProduct,
    @required this.isTitleCentered,
    @required this.isLeadingNetworkImage,
    @required this.isTrailingNetworkImage,
    @required this.isSubtitle,
    @required this.isProductList,
    @required this.title,
    @required this.subtitle,
    @required this.leadingIcon,
    @required this.trailingIcon,
    @required this.color,
    @required this.elevation,
    @required this.listTileVerticalPadding,
    @required this.leadingContainerVerticalPadding,
    @required this.leadingContainerHorizontalPadding,
    @required this.trailingContainerVerticalPadding,
    @required this.trailingContainerHorizontalPadding,
    @required this.trailingPadding,
    @required this.titleLeftPadding,
    @required this.titleTopPadding,
    @required this.titleBottomPadding,
    @required this.subTitleLeftPadding,
    @required this.subTitleTopPadding,
    @required this.subTitleBottomPadding,
    @required this.cardVerticalPadding,
    @required this.cardHorizontalPadding,
    @required this.cardBorderRadius,
    @required this.onTapMethod,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapMethod,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: cardVerticalPadding,
          horizontal: cardHorizontalPadding,
        ),
        child: isProductList
            ? Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Styleguide.color_gray_2,
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: Styleguide.color_gray_2,
                      width: 1.0,
                    ),
                  ),
                ),
                child: _buildCard(context),
              )
            : _buildCard(context),
      ),
    );
  }

  Card _buildCard(context) {
    return Card(
      key: Key('plp_tile_card_$index'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          cardBorderRadius,
        ),
      ),
      elevation: elevation,
      child: Container(
        alignment: isTitleCentered ? Alignment.center : Alignment.topCenter,
        padding: EdgeInsets.symmetric(vertical: listTileVerticalPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            cardBorderRadius,
          ),
          color: color,
        ),
        child: _buildListTile(context),
      ),
    );
  }

  ListTile _buildListTile(context) {
    return ListTile(
      title: _buildTitle(context),
      subtitle: _buildSubtitle(),
      leading: _buildLeading(),
      trailing: _buildTrailing(),
    );
  }

  Widget _buildSubtitle() {
    if (isSubtitle) {
      return Padding(
        padding: EdgeInsets.only(
          left: subTitleLeftPadding,
          top: subTitleTopPadding,
          bottom: subTitleBottomPadding,
        ),
        child: Text(
          subtitle,
        ),
      );
    }

    return null;
  }

  Widget _buildTitle(context) {
    return Padding(
      padding: EdgeInsets.only(
        left: titleLeftPadding,
        top: titleTopPadding,
        bottom: titleBottomPadding,
      ),
      child: Text(
        title,
        key: Key(title.toLowerCase().replaceAll(RegExp(r'\s+'), '_').replaceAll("'", '') + '_option'),
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: Theme.of(context).textTheme.headline5.fontFamily,
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (showLeading) {
      if (showProduct) {
        return _leadingIcon(83.0, 57.0);
      } else {
        return _leadingIcon(null, null);
      }
    }

    return null;
  }

  Container _leadingIcon(double height, double width) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: leadingContainerHorizontalPadding,
        vertical: leadingContainerVerticalPadding,
      ),
      child: isLeadingNetworkImage
          ? ProductImage(
              height: height,
              width: width,
              productImageUrl: leadingIcon,
              fit: BoxFit.contain,
            )
          : Image.asset(
          leadingIcon,
          key: Key(title.toLowerCase().replaceAll(RegExp(r'\s+'), '_').replaceAll("'", '') + '_leading_icon'),
      ),
    );
  }

  Widget _buildTrailing() {
    if (showTrailing) {
      return Container(
        padding: EdgeInsets.only(right: trailingPadding),
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: trailingContainerHorizontalPadding,
                vertical: trailingContainerVerticalPadding),
            child: isTrailingNetworkImage
                ? Image.network(
                    trailingIcon,
                  )
                : Image.asset(
                    trailingIcon,
              key: Key(title.toLowerCase().replaceAll(RegExp(r'\s+'), '_').replaceAll("'", '') + '_trailing_icon'),
                    height: 65,
                    width: 65,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      );
    } else {
      null;
    }
    return null;
  }
}
