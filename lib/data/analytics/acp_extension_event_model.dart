
class ACPExtensionEventModel{
  final String eventName;
  final String eventType;
  final String eventSource;
  final Map<String,String> data;

  ACPExtensionEventModel({
    this.eventName,
    this.eventType,
    this.eventSource,
    this.data
  });
}