import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:navigation/navigation.dart';
import 'plp_tile_widget.dart';

class LawnGoalsList extends StatelessWidget {
  final _categories = ProductCategory.values
      .where((element) => element.type == 'goals_filter')
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildLawnGoalsList(),
    );
  }

  Widget _buildLawnGoalsList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        return _buildLawnGoalsTile(index);
      },
      itemCount: _categories.length,
    );
  }

  PlpTileWidget _buildLawnGoalsTile(int index) {
    return PlpTileWidget(
      showLeading: true,
      showTrailing: true,
      showProduct: false,
      isTitleCentered: true,
      isLeadingNetworkImage: false,
      isTrailingNetworkImage: false,
      isSubtitle: false,
      isProductList: false,
      title: _categories[index].title,
      subtitle: null,
      leadingIcon: _categories[index].icon,
      trailingIcon: 'assets/icons/plp_trailing_arrow.png',
      color: Styleguide.color_gray_0,
      elevation: 0,
      listTileVerticalPadding: 12,
      onTapMethod: () {
        registry<Navigation>().push(
          '/plp/listing',
          arguments: _categories[index],
        );
      },
      cardVerticalPadding: 4,
      cardHorizontalPadding: 0,
      cardBorderRadius: 0,
      trailingPadding: 12,
      titleLeftPadding: 6,
      titleTopPadding: 0,
      titleBottomPadding: 0,
      subTitleLeftPadding: 0,
      subTitleTopPadding: 0,
      subTitleBottomPadding: 0,
      leadingContainerHorizontalPadding: 0,
      leadingContainerVerticalPadding: 4,
      trailingContainerHorizontalPadding: 0,
      trailingContainerVerticalPadding: 18,
    );
  }
}
