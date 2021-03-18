import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/screens/plp/widgets/search_icon_button.dart';
import 'package:navigation/navigation.dart';

class PlpSliverAppbar extends StatelessWidget {
  PlpSliverAppbar();

  @override
  Widget build(BuildContext context) {
    ThemeData _theme;
    _theme = Theme.of(context);

    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: false,
      backgroundColor: _theme.primaryColor,
      brightness: Brightness.dark,
      expandedHeight: 112.0,
      automaticallyImplyLeading: false,
      flexibleSpace: _buildAppBar(context, _theme),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData _theme) {
    return AppBar(
      leading: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCancelButton(context)),
      brightness: Brightness.light,
      backgroundColor: _theme.primaryColor,
      flexibleSpace: _buildStackForAppBar(context),
    );
  }

  Stack _buildStackForAppBar(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image(
          image: AssetImage('assets/images/plp_background_image.png'),
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: _buildSearchWidget(context)),
        ),
      ],
    );
  }

  GestureDetector _buildCancelButton(context) {
    return GestureDetector(
      key: Key('plp_cancel_icon'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          height: 24,
          width: 24,
          child: Image.asset(
            'assets/icons/plp_cancel_icon.png',
          ),
        ),
      ),
      onTap: () => returnToHome(),
    );
  }

  void returnToHome() {
    registry<Navigation>().popToRoot();
  }

  Widget _buildSearchWidget(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Container(
        color: Styleguide.color_gray_0,
        child: TextField(
          key: Key('find_product'),
          readOnly: true,
          onTap: () {
            registry<Navigation>().push('/plp/search');
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              left: 16,
              top: 12,
              bottom: 12,
            ),
            filled: true,
            fillColor: Styleguide.color_gray_0,
            hintText: 'Find products for your lawn',
            hintStyle: TextStyle(
              color: Styleguide.color_gray_9,
            ),
            icon: null,
            suffixIcon: SearchIconButton(),
            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
          ),
        ),
      ),
    );
  }
}
