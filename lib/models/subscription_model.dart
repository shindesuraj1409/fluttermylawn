import 'package:bus/bus.dart';
import 'package:my_lawn/data/subscription_data.dart';

class SubscriptionModel with Bus {
  @override
  List<Channel> get channels => [Channel(SubscriptionData)];
}
