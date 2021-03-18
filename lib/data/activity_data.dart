import 'package:data/data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/data/product/product_data.dart';

class ActivityData extends Data {
  ActivityData({
    this.activityId,
    this.productId,
    this.activityType,
    this.description,
    this.frequency,
    this.time,
    this.activityDate,
    this.appliedDate,
    this.completedDate,
    this.applicationWindow,
    this.recommendationId,
    this.remind = false,
    this.childProducts,
    this.name,
    this.applied = false,
    this.skipped = false,
    this.howMuchFields,
    this.duration,
  });

  final String activityId;
  final String productId;
  final ActivityType activityType;
  final String description;
  final String frequency;
  final String time;
  final DateTime activityDate;
  final DateTime appliedDate;
  final DateTime completedDate;
  final ProductApplicationWindow applicationWindow;
  final String recommendationId;
  final bool remind;
  final List<Product> childProducts;
  final String name;
  final bool applied;
  final bool skipped;
  final List<String> howMuchFields;
  final int duration;

  @override
  List<Object> get props => [
        activityId,
        productId,
        activityType,
        description,
        frequency,
        time,
        activityDate,
        appliedDate,
        completedDate,
        applicationWindow,
        recommendationId,
        remind,
        childProducts,
        name,
        applied,
        skipped,
        howMuchFields,
        duration,
      ];

  bool get isAutomaticallyDone =>
      activityDate != null &&
      activityDate.difference(DateTime.now()).isNegative;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ActivityData &&
          runtimeType == other.runtimeType &&
          activityId == other.activityId &&
          productId == other.productId &&
          activityType == other.activityType &&
          description == other.description &&
          frequency == other.frequency &&
          time == other.time &&
          activityDate == other.activityDate &&
          appliedDate == other.appliedDate &&
          completedDate == other.completedDate &&
          applicationWindow == other.applicationWindow &&
          recommendationId == other.recommendationId &&
          duration == other.duration &&
          remind == other.remind &&
          childProducts == other.childProducts &&
          howMuchFields == other.howMuchFields &&
          name == other.name;

  @override
  int get hashCode =>
      super.hashCode ^
      activityId.hashCode ^
      productId.hashCode ^
      activityType.hashCode ^
      description.hashCode ^
      frequency.hashCode ^
      time.hashCode ^
      activityDate.hashCode ^
      appliedDate.hashCode ^
      completedDate.hashCode ^
      applicationWindow.hashCode ^
      recommendationId.hashCode ^
      duration.hashCode ^
      remind.hashCode ^
      childProducts.hashCode ^
      howMuchFields.hashCode ^
      name.hashCode;

  ActivityData copyWith({
    activityId,
    productId,
    activityType,
    description,
    frequency,
    time,
    activityDate,
    appliedDate,
    completedDate,
    applicationWindow,
    recommendationId,
    duration,
    remind,
    childProducts,
    String name,
    bool applied,
    bool skipped,
    List<String> howMuchFields,
  }) {
    return ActivityData(
      activityId: activityId ?? this.activityId,
      productId: productId ?? this.productId,
      activityType: activityType ?? this.activityType,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      time: time ?? this.time,
      activityDate: activityDate ?? this.activityDate,
      applicationWindow: applicationWindow ?? this.applicationWindow,
      recommendationId: recommendationId ?? this.recommendationId,
      duration: duration ?? this.duration,
      remind: remind ?? this.remind,
      childProducts: childProducts ?? this.childProducts,
      appliedDate: appliedDate ?? this.appliedDate,
      completedDate: completedDate ?? this.completedDate,
      name: name ?? this.name,
      applied: applied ?? this.applied,
      skipped: skipped ?? this.skipped,
      howMuchFields: howMuchFields ?? this.howMuchFields,
    );
  }

  factory ActivityData.fromRecommendation(
      String recommendationId, Product product) {
    return ActivityData(
      productId: product.parentSku,
      activityType: ActivityType.fake,
      applicationWindow: product.applicationWindow,
      recommendationId: recommendationId,
      remind: false,
      childProducts: product.childProducts,
      name: product.name,
      applied: false,
      skipped: false,
    );
  }
}
