import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';


class TipsScreenAdobeState extends AdobeAnalyticState {
  final String filters;

  TipsScreenAdobeState({this.filters}) : super(type: 'TipsScreenState', state: 'tips');

  @override
  Map<String, String> getData() {
    return {
      's.filters': filters,
      's.type': 'lawncareplan'
    };
  }
}


class ArticleScreenAdobeState extends AdobeAnalyticState {
  final String articleTitle;

  ArticleScreenAdobeState({
    this.articleTitle
  }) : super(type: 'ArticleScreenState', state: 'article');

  @override
  Map<String, String> getData() {
    return {
      's.article': articleTitle,
      's.type': 'lawncareplan'
    };
  }
}
