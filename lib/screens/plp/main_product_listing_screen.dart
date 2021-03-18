import 'package:flutter/material.dart';
import 'package:my_lawn/screens/plp/widgets/categories_list.dart';
import 'package:my_lawn/screens/plp/widgets/plp_sliver_appbar.dart';
import 'package:my_lawn/screens/plp/widgets/plp_tabs_content.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';

class MainProductListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          PlpSliverAppbar(),
          CategoriesList(),
          SliverToBoxAdapter(
            child: PlpTabsContent(),
          ),
        ],
      ),
    );
  }
}
