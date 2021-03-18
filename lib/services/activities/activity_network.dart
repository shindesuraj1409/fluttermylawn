import 'package:my_lawn/data/product/product_data.dart';

class ActivityRequest {
  ActivityRequest({
    this.applicationWindow,
    this.activityId,
    this.productId,
    this.activityType,
    this.description,
    this.frequency,
    this.time,
    this.activityDate,
    this.recommendationId,
    this.reminder,
    this.status,
    this.duration,
  });

  final String activityId;
  final String productId;
  final String activityType;
  final String description;
  final String frequency;
  final String time;
  final DateTime activityDate;
  final ProductApplicationWindow applicationWindow;
  final String recommendationId;
  final String status;
  final int duration;
  final bool reminder;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'parentSku': productId,
      'activityType': activityType,
      'frequency': frequency,
      'description': description,
      'time': time,
      'activityDate': activityDate.toIso8601String(),
      'startDate': applicationWindow.startDate?.toIso8601String(),
      'endDate': applicationWindow.endDate?.toIso8601String(),
      'recommendationId': recommendationId,
      'status': status,
      'duration': duration,
      'reminder': reminder,
    };
  }
}

class ActivityResponse {
  ActivityResponse({
    this.activityId,
    this.productId,
    this.activityType,
    this.description,
    this.frequency,
    this.time,
    this.activityDate,
    this.appliedDate,
    this.completedDate,
    this.recommendationId,
    this.childProducts,
    this.applicationWindow,
    this.name,
    this.applied,
    this.skipped,
    this.duration,
    this.reminder,
  });

  final String activityId;
  final String productId;
  final String activityType;
  final String description;
  final String frequency;
  final String time;
  final DateTime activityDate;
  final DateTime appliedDate;
  final DateTime completedDate;
  final String recommendationId;
  final List<Product> childProducts;
  final ProductApplicationWindow applicationWindow;
  final String name;
  final bool applied;
  final bool skipped;
  final int duration;
  final bool reminder;

  ActivityResponse.fromJson(Map<String, dynamic> map)
      : activityId = map['activityId'] as String,
        productId = map['parentSku'] as String,
        activityType = map['activityType'] as String,
        frequency = map['frequency'] as String,
        time = map['time'] as String,
        activityDate = map['activityDate'] != null
            ? DateTime.tryParse(map['activityDate'] as String)
            : null,
        recommendationId = map['recommendationId'] as String,
        description = map['description'] as String,
        childProducts = List<Product>.from(map['childProducts']?.map(
              (product) => Product.fromJson(product),
            ) ??
            []),
        applicationWindow = ProductApplicationWindow(
          startDate: map['startDate'] != null
              ? DateTime.tryParse(map['startDate'] as String)
              : null,
          endDate: map['endDate'] != null
              ? DateTime.tryParse(map['endDate'] as String)
              : null,
        ),
        appliedDate = map['appliedDate'] != null
            ? DateTime.tryParse(map['appliedDate'] as String)
            : null,
        completedDate = map['completedAt'] != null
            ? DateTime.tryParse(map['completedAt'] as String)
            : null,
        name = map['name'] as String,
        applied = map['status'] == 'applied',
        skipped = map['status'] == 'skipped',
        duration = map['duration'] as int,
        reminder = map['reminder'] as bool;
}

class ActivitiesListResponse {
  final List<ActivityResponse> activities;

  ActivitiesListResponse.fromJson(Map<String, dynamic> map)
      : activities = List<ActivityResponse>.from(
          map['activities']?.map(
                (note) => ActivityResponse.fromJson(note),
              ) ??
              [],
        );
}
