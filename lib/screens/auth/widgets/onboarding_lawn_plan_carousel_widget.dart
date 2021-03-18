import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

class OnboardingLawnPlanCarousel extends StatefulWidget {
  @override
  _OnboardingLawnPlanCarouselState createState() =>
      _OnboardingLawnPlanCarouselState();
}

class _OnboardingLawnPlanCarouselState extends State<OnboardingLawnPlanCarousel>
    with TickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  final carouselAssets = [
    'assets/images/onboarding_text1.png',
    'assets/images/onboarding_text2.png',
    'assets/images/onboarding_text3.png',
    'assets/images/onboarding_text4.png'
  ];
  final carouselTexts = [
    'Tell us about your lawn and we’ll give you an easy-to-follow plan — created specifically for your yard.',
    'With our application reminders, we will tell you the best time to apply your products. We take out the guesswork of when to apply.',
    'Get inspiration and other tips on how to keep your lawn lush and beautiful.',
    'Subscribe to your custom lawn care plan and we’ll ship you the products right to your door!'
  ];

  final carouselHeights = [76.0, 76.0, 76.0, 114.0];

  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);

  int _currentPage = 0;

  List<Widget> _buildPageIndicators() {
    final list = <Widget>[];
    for (var i = 0; i < _numPages; i++) {
      list.add(
        i == _currentPage ? _buildIndicator(true) : _buildIndicator(false),
      );
    }
    return list;
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color:
            isActive ? Theme.of(context).primaryColor : Styleguide.color_gray_2,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    final pages = <Widget>[];
    for (var i = 0; i < _numPages; i++) {
      pages.add(
        _buildCarouselItemWidget(
          carouselAssets[i],
          carouselTexts[i],
          carouselHeights[i],
        ),
      );
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: PageView(
              physics: const ClampingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _buildPages(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicators(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCarouselItemWidget(
      String imageTitle, String description, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            imageTitle,
            height: height,
            width: 300,
            fit: BoxFit.contain,
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Styleguide.color_gray_4,
                  fontWeight: FontWeight.w400,
                ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
