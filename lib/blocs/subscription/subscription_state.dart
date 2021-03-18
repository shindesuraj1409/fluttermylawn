part of 'subscription_bloc.dart';

enum SubscriptionStatus {
  active,
  pending,
  canceled,
  loading,
  none,
  error,
  preview,
  updated,
  same
}

extension SubscriptionStatusExtension on SubscriptionStatus {
  String get string {
    switch (this) {
      case SubscriptionStatus.active:
        return 'ACTIVE';
      case SubscriptionStatus.preview:
        return 'PREVIEW';
      case SubscriptionStatus.updated:
        return 'UPDATED';
      case SubscriptionStatus.same:
        return 'SAME';
      case SubscriptionStatus.canceled:
        return 'CANCELED';
      case SubscriptionStatus.pending:
        return 'PENDING';
      case SubscriptionStatus.loading:
        return 'LOADING';
      case SubscriptionStatus.error:
        return 'ERROR';
      case SubscriptionStatus.none:
        return 'NONE';
      default:
        throw UnimplementedError('Missing string for $this');
    }
  }

  bool get hasSubscriptionData =>
      this == SubscriptionStatus.active ||
      this == SubscriptionStatus.pending ||
      this == SubscriptionStatus.canceled;

  bool get isActive => this == SubscriptionStatus.active;
  bool get isPending => this == SubscriptionStatus.pending;
  bool get isError => this == SubscriptionStatus.error;
  bool get isLoading => this == SubscriptionStatus.loading;
  bool get isCanceled => this == SubscriptionStatus.canceled;
  bool get isNone => this == SubscriptionStatus.none;
  bool get isPreview => this == SubscriptionStatus.preview;
}

class SubscriptionState extends Equatable {
  const SubscriptionState._({
    this.data,
    this.status = SubscriptionStatus.none,
    this.errorMessage = '',
  });

  final List<SubscriptionData> data;
  final SubscriptionStatus status;

  final String errorMessage;

  const SubscriptionState.none() : this._();

  const SubscriptionState.pending(
      List<SubscriptionData> data, SubscriptionStatus status)
      : this._(data: data, status: SubscriptionStatus.pending);

  const SubscriptionState.canceled(
      List<SubscriptionData> data, SubscriptionStatus status)
      : this._(data: data, status: SubscriptionStatus.canceled);

  const SubscriptionState.active(
      List<SubscriptionData> data, SubscriptionStatus status)
      : this._(data: data, status: SubscriptionStatus.active);

  const SubscriptionState.loading()
      : this._(status: SubscriptionStatus.loading);

  const SubscriptionState.same() : this._(status: SubscriptionStatus.same);

  const SubscriptionState.updated(List<SubscriptionData> data)
      : this._(status: SubscriptionStatus.updated, data: data);

  const SubscriptionState.preview(
    List<SubscriptionData> data,
  ) : this._(status: SubscriptionStatus.preview, data: data);

  const SubscriptionState.error(String errorMessage)
      : this._(status: SubscriptionStatus.error, errorMessage: errorMessage);

  @override
  List<Object> get props => [status, data];
}
