import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:navigation/navigation.dart';
import 'plp_tile_widget.dart';

class CategoriesProductsList extends StatelessWidget {
  final List<Product> product;

  CategoriesProductsList({this.product});

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        child: buildCategoriesProductsList(),
      );
    } catch (e) {
      return Center(
        child: Text(
          'Something went wrong. Please try again',
        ),
      );
    }
  }

  Widget buildCategoriesProductsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        return _buildCategoriesProductsTile(index);
      },
      itemCount: product.length,
    );
  }

  PlpTileWidget _buildCategoriesProductsTile(int index) {
    return PlpTileWidget(
      showLeading: true,
      showTrailing: false,
      showProduct: true,
      isTitleCentered: false,
      isLeadingNetworkImage: true,
      isTrailingNetworkImage: false,
      isSubtitle: true,
      isProductList: true,
      title: product[index].name,
      subtitle: '', // TODO Subscription data implementation
      leadingIcon: product[index].imageUrl != ''
          ? product[index].imageUrl
          : Text('No Image'),
      trailingIcon: null,
      color: Styleguide.color_gray_0,
      elevation: 0,
      listTileVerticalPadding: 16,
      onTapMethod: () {
        registry<Navigation>()
            .push('/product/detail', arguments: product[index]);
      },
      cardVerticalPadding: 0,
      cardHorizontalPadding: 0,
      cardBorderRadius: 0,
      trailingPadding: 0,
      titleLeftPadding: 12,
      titleTopPadding: 0,
      titleBottomPadding: 8,
      subTitleLeftPadding: 16,
      subTitleTopPadding: 0,
      subTitleBottomPadding: 0,
      leadingContainerHorizontalPadding: 0,
      leadingContainerVerticalPadding: 0,
      trailingContainerHorizontalPadding: 0,
      trailingContainerVerticalPadding: 0,
    );
  }
}
