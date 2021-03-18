import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/tips/filter_block_data.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';

class Filter with EquatableMixin {
  final List<TipsArticleData> articles;
  final List<FilterBlockData> filters;
  List<String> _appliedFilters;
  List<String> _partialFilters;

  Filter({this.articles, this.filters, appliedFilters, partialFilters}) {
    _appliedFilters = appliedFilters ?? [];
    _partialFilters = appliedFilters != null
        ? appliedFilters.map<String>((String e) => e).toList()
        : [];
  }
  Filter copyWith({articles, filters, appliedFilters, partialFilters}) {
    articles = articles ?? this.articles;
    filters = filters ?? this.filters;
    _appliedFilters = appliedFilters ?? _appliedFilters;
    _partialFilters = partialFilters ?? _partialFilters;
    return Filter(
        articles: articles,
        filters: filters,
        appliedFilters: _appliedFilters,
        partialFilters: _partialFilters);
  }

  //Setters
  void applyPartialFilters(List<String> filterIds) {
    _partialFilters.addAll(filterIds);
    //remove duplicates
    _partialFilters = LinkedHashSet<String>.from(_partialFilters).toList();
  }

  void removePartialFilters(List<String> filterIds) {
    _partialFilters.removeWhere((element) => filterIds.contains(element));
    // remove duplicates
    _partialFilters = LinkedHashSet<String>.from(_partialFilters).toList();
  }

  set appliedFilters(List<String> filters) => _appliedFilters = filters;

  set partialFilters(List<String> filters) => _partialFilters = filters;

  //Getters

  List<String> get partialFilters => _partialFilters;

  List<String> get appliedFilters => _appliedFilters;

  List<TipsArticleData> get filteredArticles {
    var filteredArticles = <TipsArticleData>[];
    for (var filter in _partialFilters) {
      filteredArticles.addAll(
          articles.where((article) => article.typeIdList.contains(filter)));
    }
    filteredArticles =
        LinkedHashSet<TipsArticleData>.from(filteredArticles).toList();
    return filteredArticles;
  }

  @override
  List<Object> get props =>
      [articles, filteredArticles, filters, appliedFilters];
}
