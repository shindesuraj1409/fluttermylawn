import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/tips/filter_block_data.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/services/contentful/i_contentful_service.dart';
import 'package:my_lawn/services/contentful/tips/i_tips_service.dart';

class TipsServiceImpl implements TipsService {
  final ContentfulService _contentfulService = registry<ContentfulService>();

  @override
  Future<List<TipsArticleData>> getBodyTips({int skip, int limit}) async {
    //filter only body tips exclude featured articles
    //lets not hardcode the featured article
    final contentfulTips = await _contentfulService.getEntries(params: {
      'content_type': 'lawnTipArticle',
      'fields.categories.sys.id[nin]': 'oDubG2vMJBAWo1FZkCc3P',
      // to fetch paginated tips uncomment the following:
      // 'skip': skip,
      // 'limit': limit,
    });

    final items = contentfulTips['items'] as List;
    final contentfulTipsList = items
        .map((e) => TipsArticleData.fromJson(
            json: e['fields'],
            assets: contentfulTips['includes']['Asset'],
            entries: contentfulTips['includes']['Entry']))
        .toList();
    return contentfulTipsList;
  }

  @override
  Future<List<FilterBlockData>> getFilters() async {
    final contentfulFilters = await _contentfulService.getEntries(
        params: {'content_type': 'lawnTipArticleFilter', 'include': '1'});

    //the filter list
    final filters = (contentfulFilters['items'] as List)
        .map((e) =>
            FilterBlockData.fromJson(e, contentfulFilters['includes']['Entry']))
        .toList();

    return filters;
  }

  @override
  Future<List<TipsArticleData>> getHeroTips() async {
    //lets not hardcode the article
    final contentfulHeroTips = await _contentfulService.getEntries(params: {
      'content_type': 'lawnTipArticle',
      'fields.categories.sys.id[in]': 'oDubG2vMJBAWo1FZkCc3P',
    });
    final items = contentfulHeroTips['items'] as List;
    final contentfulTipsList = items
        .map((e) => TipsArticleData.fromJson(
            json: e['fields'],
            assets: contentfulHeroTips['includes']['Asset'],
            entries: contentfulHeroTips['includes']['Entry']))
        .toList();
    return contentfulTipsList;
  }

  @override
  Future<TipsArticleData> getArticle(String articleId) async {
    final response = await _contentfulService.getEntries(
        params: {'content_type': 'lawnTipArticle', 'sys.id': articleId});
    final article = TipsArticleData.fromJson(
      json: response['items'].first['fields'],
      assets: response['includes']['Asset'],
      entries: response['includes']['Entry']
    );
    return article;
  }
}
