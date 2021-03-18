import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/product/product_category.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/PLP_screen/state.dart';
import 'package:navigation/navigation.dart';
import 'plp_tile_widget.dart';

class CategoriesList extends StatelessWidget {
  final _categories = ProductCategory.values
      .where((element) => element.type == 'mylawn_categories')
      .toList();

  @override
  Widget build(BuildContext context) {
    return _buildCategoriesList();
  }

  SliverPadding _buildCategoriesList() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, index) {
            return _buildcategoriesTile(index);
          },
          childCount: _categories.length,
        ),
      ),
    );
  }

  PlpTileWidget _buildcategoriesTile(int index) {
    return PlpTileWidget(
      showLeading: false,
      showTrailing: true,
      showProduct: false,
      isTitleCentered: false,
      isLeadingNetworkImage: false,
      isTrailingNetworkImage: false,
      isSubtitle: false,
      isProductList: false,
      title: ProductCategory.values[index].title,
      subtitle: null,
      leadingIcon: null,
      trailingIcon: ProductCategory.values[index].icon,
      elevation: 1,
      color: ProductCategory.values[index].color,
      trailingContainerVerticalPadding: 0,
      trailingContainerHorizontalPadding: 0,
      onTapMethod: () {
        registry<AdobeRepository>().trackAppState(
          ProductCategoryScreenAdobeState(category: _categories[index]),
        );
        //send the instace of the bloc to the screen
        registry<Navigation>().push(
          '/plp/listing',
          arguments: _categories[index],
        );
      },
      cardVerticalPadding: 4,
      cardHorizontalPadding: 16,
      cardBorderRadius: 8,
      trailingPadding: 14,
      titleLeftPadding: 20,
      titleTopPadding: 0,
      titleBottomPadding: 0,
      subTitleLeftPadding: 0,
      subTitleTopPadding: 0,
      subTitleBottomPadding: 0,
      listTileVerticalPadding: 20,
      leadingContainerHorizontalPadding: null,
      leadingContainerVerticalPadding: null,
    );
  }
}
