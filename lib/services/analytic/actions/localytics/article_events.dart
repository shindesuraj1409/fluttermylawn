import 'package:localytics_plugin/events/localytics_event.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/tips/tips_article_data.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';

class ReadHeroArticleEvent extends LocalyticsEvent {
  ReadHeroArticleEvent(this.heroTitle, this.date)
      : super(
          eventName: 'Read hero article',
          extraAttributes: {
            'Hero title': heroTitle,
            'Date': date,
          },
        );

  final String heroTitle;
  final String date;
}

class ReadFeedArticle extends LocalyticsEvent {
  ReadFeedArticle({
    this.feedTitle,
    this.feedType,
    this.date,
    this.source,
    this.tags,
  }) : super(
          eventName: 'Read feed article',
          extraAttributes: {
            'Feed article title': feedTitle,
            'Feed article type': feedType,
            'Date': date,
            'Source of article': source,
            'Tags': tags,
          },
        );

  final String feedTitle;
  final String feedType;
  final String date;
  final String source;
  final String tags;
}

void tagTipEvent(TipsArticleData tipsCardModel) {
  LocalyticsEvent event;
  if (tipsCardModel.type.contains('Lawn Food')) {
    event = ReadFeedArticle(
      feedTitle: tipsCardModel.title,
      feedType: tipsCardModel.type.toString(),
      date: DateTime.now().toString(),
    );
  } else {
    event = ReadHeroArticleEvent(
      tipsCardModel.title,
      DateTime.now().toString(),
    );
  }

  registry<LocalyticsService>().tagEvent(event);
}
