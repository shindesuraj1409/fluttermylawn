import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/screens/plp/widgets/lawn_goals_list.dart';
import 'package:my_lawn/screens/plp/widgets/lawn_problems_list.dart';

class PlpTabsContent extends StatefulWidget {
  @override
  _PlpTabsContentState createState() => _PlpTabsContentState();
}

class _PlpTabsContentState extends State<PlpTabsContent>
    with TickerProviderStateMixin {
  ThemeData _theme;

  TabController _tabController;

  int _selectedTab = 0;

  @override
  void initState() {
    _tabController =
        TabController(initialIndex: _selectedTab, length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    super.didChangeDependencies();
  }

  void _didSelectTab(int index) {
    setState(() => _selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTabbedDetailRow();
  }

  Widget _buildTabbedDetailRow() {
    return Container(
      color: Styleguide.color_gray_1,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: _title(),
          ),
          _buildTabController(),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 20,
      ),
      child: Text('Need help with finding products?',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3),
    );
  }

  Widget _buildTabController() {
    return Container(
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: true,
        controller: _tabController,
        labelPadding: EdgeInsets.only(bottom: 12, right: 10, left: 10),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: _theme.colorScheme.primary,
            width: 2.0,
          ),
        ),
        tabs: [
          Column(
            children: <Widget>[
              Text(
                'LAWN PROBLEMS',
                style: _theme.textTheme.bodyText1.copyWith(
                  color: _selectedTab == 0
                      ? Styleguide.color_green_4
                      : Styleguide.color_gray_9,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text(
                'LAWN GOALS',
                style: _theme.textTheme.bodyText1.copyWith(
                  color: _selectedTab == 1
                      ? Styleguide.color_green_4
                      : Styleguide.color_gray_9,
                ),
              ),
            ],
          ),
        ],
        onTap: (index) => _didSelectTab(index),
      ),
    );
  }

  Widget _buildTabContent() {
    Widget _buildLawnProblemsTab() {
      return LawnProblemsList();
    }

    Widget _buildLawnGoalsTab() {
      return LawnGoalsList();
    }

    return _selectedTab == 0 ? _buildLawnProblemsTab() : _buildLawnGoalsTab();
  }
}
