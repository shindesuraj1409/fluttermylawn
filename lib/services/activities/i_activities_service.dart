import 'package:my_lawn/data/activity_data.dart';

abstract class ActivitiesService {
  Stream<List<ActivityData>> get activitiesStream;

  Future<void> createActivity(
    String customerId,
    ActivityData activityData,
  );

  Future<void> waitForActivities(String customerId, String recommendationId);

  Future<void> getActivities(String customerId);

  Future<List<ActivityData>> copyWithGraphQL({
    List<ActivityData> activities,
    List<String> products,
  });

  Future<void> updateActivity(
    String customerId,
    ActivityData activityData,
  );

  Future<void> deleteActivity(
    String customerId,
    String activityId,
  );
}
