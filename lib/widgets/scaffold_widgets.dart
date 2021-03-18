import 'dart:math';
import 'package:bus/bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/back_button_state.dart';
import 'package:my_lawn/extensions/route_arguments_extension.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/models/app_model.dart';
import 'package:navigation/navigation.dart';

/// A no-frills scaffold.
class BasicScaffold extends StatelessWidget {
  final Widget child;
  final Widget drawer;
  final Widget bottomNavigationBar;
  final Color backgroundColor;
  final bool allowBackNavigation;
  final Key scaffoldKey;

  BasicScaffold({
    @required this.child,
    this.drawer,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.allowBackNavigation = true,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return WillPopScope(
      onWillPop: () async =>
          allowBackNavigation &&
          busSnapshot<AppModel, BackButtonState>() == BackButtonState.Enabled,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: backgroundColor ?? Theme.of(context).backgroundColor,
        body: child,
        drawer: drawer,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

/// A scaffold with an app bar.
class BasicScaffoldWithAppBar extends StatelessWidget {
  final Widget child;
  final Widget bottom;
  final Widget drawer;
  final Widget leading;
  final String titleString;
  final double titleLeadingPadding;
  final Widget trailing;
  final Color backgroundColor;
  final Color appBarBackgroundColor;
  final Color appBarForegroundColor;
  final double appBarElevation;
  final bool isNotUsingWillPop;
  final Brightness appBarBrightness;
  final Key scaffoldKey;

  BasicScaffoldWithAppBar({
    @required this.child,
    this.bottom,
    this.drawer,
    this.leading,
    this.titleString,
    this.isNotUsingWillPop = false,
    this.titleLeadingPadding = 0.0,
    this.trailing,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.appBarBrightness,
    this.appBarElevation = 4.0,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final theme = Theme.of(context);
    if (isNotUsingWillPop) {
      return buildScaffold(theme, context);
    } else {
      return WillPopScope(
        onWillPop: () async =>
            busSnapshot<AppModel, BackButtonState>() == BackButtonState.Enabled,
        child: buildScaffold(theme, context),
      );
    }
  }

  Scaffold buildScaffold(ThemeData theme, BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? theme.backgroundColor,
      key: scaffoldKey,
      appBar: AppBar(
        brightness: appBarBrightness ?? theme.appBarTheme.brightness,
        backgroundColor: appBarBackgroundColor ?? theme.appBarTheme.color,
        elevation: appBarElevation,
        title: Padding(
          padding: EdgeInsets.only(
            left: titleLeadingPadding,
            right: 24.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleString == null
                  ? Container()
                  : Text(
                      titleString,
                      style: Theme.of(context).textTheme.headline1.apply(
                            fontSizeFactor: 0.75,
                            color: appBarForegroundColor,
                          ),
                      key: Key(titleString
                          .toLowerCase()
                          .replaceAll(RegExp(r'\s+'), '_')),
                    ),
              if (trailing != null) trailing,
            ],
          ),
        ),
        titleSpacing: -8.0,
        centerTitle: false,
        leading: leading ??
            busStreamBuilder<Navigation, NavigationData>(
              builder: (context, navigation, data) => Visibility(
                child: busStreamBuilder<AppModel, BackButtonState>(
                  builder: (context, appService, backState) => IgnorePointer(
                    ignoring: backState == BackButtonState.Disabled,
                    child: BackButton(
                      key: Key('back_button'),
                      color: appBarForegroundColor ??
                          theme.colorScheme.onBackground,
                      onPressed: registry<Navigation>().pop,
                    ),
                  ),
                ),
                maintainState: true,
                visible:
                    routeName(context) == data.currentRouteName && data.canPop,
              ),
            ),
      ),
      body: child,
      drawer: drawer,
      bottomNavigationBar: bottom,
    );
  }
}

/// A scaffold with an animated, collapsing app bar.
class BasicScaffoldWithSliverAppBar extends StatefulWidget {
  final Widget child;
  final List<Widget> slivers;
  final Widget bottom;
  final Widget drawer;
  final Widget leading;
  final String titleString;
  final TextStyle titleTextStyle;
  final double titleLeadingPadding;
  final Widget trailing;
  final List<Widget> actions;
  final bool isNotUsingWillPop;
  final Color backgroundColor;
  final Color appBarBackgroundColor;
  final Color appBarForegroundColor;
  final Brightness appBarBrightness;
  final double appBarElevation;
  final double appBarSecondLineHeight;
  final bool childFillsRemainingSpace;
  final bool hasScrollBody;
  final Widget appBarSecondLine;
  final ScrollController scrollController;

  BasicScaffoldWithSliverAppBar({
    this.actions,
    this.child,
    this.slivers,
    this.bottom,
    this.drawer,
    this.leading,
    this.titleString,
    this.titleTextStyle,
    this.titleLeadingPadding,
    this.trailing,
    this.backgroundColor,
    this.isNotUsingWillPop = false,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.appBarBrightness,
    this.appBarElevation = 4.0,
    this.childFillsRemainingSpace = true,
    this.hasScrollBody = false,
    this.appBarSecondLineHeight,
    this.appBarSecondLine,
    this.scrollController,
  }) : assert(((child != null && slivers == null) ||
                (child == null && slivers != null)) &&
            ((appBarSecondLine == null) ||
                (appBarSecondLine != null && appBarSecondLineHeight != null)));

  @override
  _BasicScaffoldWithSliverAppBarState createState() =>
      _BasicScaffoldWithSliverAppBarState();
}

class _BasicScaffoldWithSliverAppBarState
    extends State<BasicScaffoldWithSliverAppBar> with RouteMixin {
  final _flexibleAppBarKey = UniqueKey();
  ScrollController _scrollController;
  final _maxScrollOffset = 40.0;

  @override
  void initState() {
    super.initState();
    _scrollController = widget?.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final theme = Theme.of(context);
    if (widget.isNotUsingWillPop) {
      return buildScaffold(theme);
    } else {
      return WillPopScope(
        onWillPop: () async =>
            busSnapshot<AppModel, BackButtonState>() == BackButtonState.Enabled,
        child: buildScaffold(theme),
      );
    }
  }

  Scaffold buildScaffold(ThemeData theme) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? theme.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            brightness: widget.appBarBrightness ?? theme.appBarTheme.brightness,
            backgroundColor:
                widget.appBarBackgroundColor ?? theme.appBarTheme.color,
            automaticallyImplyLeading: false,
            elevation: widget.appBarElevation,
            leading: widget.leading ??
                busStreamBuilder<Navigation, NavigationData>(
                  builder: (context, navigation, data) => Visibility(
                    child: busStreamBuilder<AppModel, BackButtonState>(
                      builder: (context, appService, backState) =>
                          IgnorePointer(
                        ignoring: backState == BackButtonState.Disabled,
                        child: BackButton(
                          color: widget.appBarForegroundColor ??
                              theme.colorScheme.onBackground,
                          key: Key('back_button'),
                          onPressed: registry<Navigation>().pop,
                        ),
                      ),
                    ),
                    maintainState: true,
                    visible: routeName == data.currentRouteName && data.canPop,
                  ),
                ),
            expandedHeight: widget.titleString == null
                ? kToolbarHeight
                : widget.appBarSecondLineHeight == null
                    ? kToolbarHeight + _maxScrollOffset
                    : kToolbarHeight +
                        _maxScrollOffset +
                        widget.appBarSecondLineHeight,
            collapsedHeight: widget.appBarSecondLineHeight != null
                ? kToolbarHeight + widget.appBarSecondLineHeight
                : null,
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: _FlexibleAppBar(
              key: _flexibleAppBarKey,
              scrollController: _scrollController,
              backgroundColor:
                  widget.appBarBackgroundColor ?? theme.appBarTheme.color,
              appBarSecondLineHeight: widget.appBarSecondLineHeight,
              foregroundColor: widget.appBarForegroundColor,
              minScrollOffset: 0,
              maxScrollOffset: _maxScrollOffset,
              titleString: widget.titleString,
              titleTextStyle: widget.titleTextStyle,
              titleLeadingPadding:
                  widget.titleLeadingPadding ?? theme.iconTheme.size,
              trailing: widget.trailing,
              withAction: widget.actions != null,
            ),
            actions: widget.actions,
            bottom: widget.appBarSecondLine != null
                ? PreferredSize(
                    preferredSize: Size(0, 0), child: widget.appBarSecondLine)
                : null,
          ),
          if (widget.slivers != null) ...widget.slivers,
          if (widget.child != null)
            widget.childFillsRemainingSpace
                ? SliverFillRemaining(
                    child: widget.child,
                    hasScrollBody: widget.hasScrollBody,
                  )
                : SliverToBoxAdapter(
                    child: widget.child,
                  )
        ],
      ),
      drawer: widget.drawer,
      bottomNavigationBar: widget.bottom,
    );
  }
}

class _FlexibleAppBar extends StatefulWidget {
  final ScrollController scrollController;
  final double minScrollOffset;
  final double maxScrollOffset;
  final double appBarSecondLineHeight;
  final Color backgroundColor;
  final Color foregroundColor;
  final String titleString;
  final TextStyle titleTextStyle;
  final double titleLeadingPadding;
  final bool withAction;
  final Widget trailing;

  _FlexibleAppBar({
    @required Key key,
    @required this.scrollController,
    this.minScrollOffset = double.negativeInfinity,
    this.maxScrollOffset = double.infinity,
    @required this.backgroundColor,
    this.foregroundColor,
    this.titleString,
    this.titleTextStyle,
    this.titleLeadingPadding = 0.0,
    this.withAction = false,
    this.trailing,
    this.appBarSecondLineHeight,
  }) : super(key: key);

  @override
  __FlexibleAppBarState createState() => __FlexibleAppBarState();
}

class __FlexibleAppBarState extends State<_FlexibleAppBar> {
  var _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _onScroll();
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);

    super.dispose();
  }

  void _onScroll() {
    final offset = min(
      max(widget.scrollController.offset, widget.minScrollOffset),
      widget.maxScrollOffset,
    );

    if (offset != _scrollOffset) {
      setState(() => _scrollOffset = offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final offsetFactor = _scrollOffset / widget.maxScrollOffset;
    final fontSizeFactor = min(
      1.0,
      max(0.75, 1.0 - offsetFactor / 4),
    );
    final extraTitlePadding = widget.titleLeadingPadding == 0
        ? 0
        : (16.0 + widget.titleLeadingPadding) * offsetFactor;
    final extraTitleLeftPadding = widget.withAction ? 50.0 * offsetFactor : 0.0;

    return FlexibleSpaceBarSettings(
      toolbarOpacity: 1.0,
      currentExtent: 1.0,
      minExtent: 1.0,
      maxExtent: 1.0,
      child: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.titleString == null
                    ? Container()
                    : Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.titleString,
                            style: widget.titleTextStyle != null
                                ? widget.titleTextStyle.apply(
                                    fontSizeFactor: fontSizeFactor,
                                    color: widget.foregroundColor,
                                  )
                                : Theme.of(context).textTheme.headline1.apply(
                                      fontSizeFactor: fontSizeFactor,
                                      color: widget.foregroundColor,
                                    ),
                            key: Key('header_title'),
                          ),
                        ),
                      ),
                if (widget.trailing != null) widget.trailing,
              ],
            ),
            SizedBox(
              height: widget.appBarSecondLineHeight,
            )
          ],
        ),
        titlePadding: EdgeInsets.fromLTRB(
          16 + extraTitlePadding,
          0,
          16 + extraTitleLeftPadding,
          16,
        ),
        centerTitle: false,
      ),
    );
  }
}
