import 'package:equatable/equatable.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialProductEvent extends ProductEvent {}

class ProductBlocReady extends ProductEvent {
  final SubscriptionData subscription;
  final Recommendation recommendation;
  final List<ActivityData> activityList;

  ProductBlocReady({
    this.subscription,
    this.recommendation,
    this.activityList,
  });

  @override
  List<Object> get props => [subscription, recommendation, activityList];
}

class ProductFetchEvent extends ProductEvent {
  final Product product;

  ProductFetchEvent({this.product});

  @override
  List<Object> get props => [product];
}

class DeleteProductActivitiesEvent extends ProductEvent {
  final Product product;

  DeleteProductActivitiesEvent({this.product});

  @override
  List<Object> get props => [product];
}
