import 'package:my_lawn/data/tips/filter_block_data.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';

abstract class TipsService {
  ///Get Tips
  Future<List<TipsArticleData>> getBodyTips({int skip, int limit});

  Future<List<TipsArticleData>> getHeroTips();

  Future<List<FilterBlockData>> getFilters();
  
  Future<TipsArticleData> getArticle(String articleId);
}
