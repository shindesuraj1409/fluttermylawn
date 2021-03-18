import 'package:data/data.dart';

class RecommendedProductData extends Data {
  final String description;
  final String image;
  final String url;

  RecommendedProductData({this.description, this.image, this.url});

  factory RecommendedProductData.fromJson(Map<String, dynamic> json, assets) {
    var imageUrl = 'http:';
    imageUrl += assets.firstWhere((el) =>
            el['sys']['id'] == json['fields']['image']['sys']['id'])['fields']
        ['file']['url'];
    return RecommendedProductData(
      image: imageUrl,
      description: json['fields']['name'],
      url: json['fields']['url'],
    );
  }

  @override
  List<Object> get props => [description, url, image];
}

class TipsArticleData extends Data {
  final List<String> type;
  final List<String> typeIdList;
  final String title;
  final Map<String, dynamic> contentfulPage;
  final String shortDescription;
  final int readTime;
  final String image;
  final bool isVideoArticle;
  final List<dynamic> assets;
  final List<dynamic> entries;
  // final List<dynamic> relatedArticles;
  final RecommendedProductData recommendedProduct;
  final bool isFeatured;

  TipsArticleData({
    this.typeIdList,
    this.isVideoArticle,
    // this.relatedArticles,
    this.recommendedProduct,
    this.contentfulPage,
    this.type,
    this.title,
    this.shortDescription,
    this.readTime,
    this.isFeatured = false,
    this.image,
    this.assets,
    this.entries,
  });

  factory TipsArticleData.fromJson({
    Map<String, dynamic> json,
    List<dynamic> assets,
    List<dynamic> entries,
  }) {
    final type = <String>[];
    RecommendedProductData recommendedProduct;
    final recommendedProductId = json['recommendedProduct'] != null
        ? json['recommendedProduct']['sys']['id']
        : null;
    var url = '';

    if (recommendedProductId != null) {
      recommendedProduct = RecommendedProductData.fromJson(
          entries.firstWhere(
              (entry) => entry['sys']['id'] == recommendedProductId),
          assets);
    }

    var typeIdList = <String>[];

    if (json['categories'] != null) {
      typeIdList = json['categories']
          .map<String>((e) => e['sys']['id'] as String)
          .toList();

      //get the type names (might have more than one)
      typeIdList.forEach((id) {
        type.add(entries
            .firstWhere((entry) => entry['sys']['id'] == id)['fields']['name']);
      });
    }

    //determine wether is a `featured` content and take the featured field from the types
    final isFeatured = type.remove('Featured');

    var imageId;

    if (json['heroImage'] != null) {
      imageId = json['heroImage']['sys']['id'];
    }
    if (imageId != null) {
      url = 'http:' +
          assets.firstWhere((el) => el['sys']['id'] == imageId)['fields']
              ['file']['url'];
    } else {
      url = null;
    }

    final readTime = json['estimatedReadTime'];

    final isVideoArticle = json['isAVideoArticle'] ?? false;

    return TipsArticleData(
        // relatedArticles: ,
        isVideoArticle: isVideoArticle,
        typeIdList: typeIdList,
        recommendedProduct: recommendedProduct,
        isFeatured: isFeatured,
        entries: entries,
        assets: assets,
        contentfulPage: json['content'],
        shortDescription: json['shortDescription'],
        image: url,
        title: json['title'] as String,
        readTime: readTime,
        type: type);
  }

  @override
  List<Object> get props => [type, typeIdList, title];
}
