import 'package:data/data.dart';

enum FaqCategory {
  unknown,
  subscription,
  billingAndShipping,
}

class FaqItem extends Data {
  final String question;
  final Map<String, dynamic> answer;
  final String id;

  FaqItem({
    this.question,
    this.answer,
    this.id,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json, List<dynamic> entries) {
    final entry = entries.firstWhere(
        (element) => element['sys']['id'] == json['sys']['id'],
        orElse: () => null);
    if (entry['fields']['showOnMobile'] == false) {
      return FaqItem();
    }
    return FaqItem(
        answer: entry['fields']['answer'],
        question: entry['fields']['question'],
        id: entry['sys']['id'],
        );
  }

  @override
  List<Object> get props => [question, answer];
}

class FaqData extends Data {
  final List<FaqItem> faqItems;
  final FaqCategory category;

  FaqData({this.category, this.faqItems});

  factory FaqData.fromJson(Map<String, dynamic> json, List<dynamic> entries) {
    List<FaqItem> faqItems = json['fields']['questionAndAnswer']
        .map<FaqItem>((item) => FaqItem.fromJson(item, entries))
        .toList();
    //remove empty items
    faqItems =
        faqItems.where((element) => element.question.isNotEmpty).toList();
    return FaqData(category: _categoryFromJson(json), faqItems: faqItems);
  }

  @override
  List<Object> get props => [category, faqItems];
}

FaqCategory _categoryFromJson(Map<String, dynamic> json) {
  final title = json['fields']['listTitle'] as String;
  if (title.toLowerCase().contains('plans')) {
    return FaqCategory.subscription;
  }
  if (title.toLowerCase().contains('billing')) {
    return FaqCategory.billingAndShipping;
  }
  return FaqCategory.unknown;
}
