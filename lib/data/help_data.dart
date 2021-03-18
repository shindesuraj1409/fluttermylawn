import 'package:data/data.dart';

class HelpData extends Data {
  final bool isAboutTheAppArticle;
  final Map<String, dynamic> content;
  final String title;
  final String image;
  final List assets;

  HelpData({
    this.isAboutTheAppArticle,
    this.content,
    this.title,
    this.image,
    this.assets,
  });

  factory HelpData.fromJson({Map<String, dynamic> json, List assets}) {
    final fields = json['fields'];

    final title = fields['title'];

    final isAboutTheApp = fields['isAboutTheAppArticle'];

    final content = fields['content'];

    final image = 'http:' +
        assets.firstWhere((element) =>
                element['sys']['id'] == fields['image']['sys']['id'])['fields']
            ['file']['url'];

    return HelpData(
      assets: assets,
      content: content,
      image: image,
      isAboutTheAppArticle: isAboutTheApp,
      title: title,
    );
  }

  @override
  List<Object> get props =>
      [isAboutTheAppArticle, content, title, image, assets];
}
