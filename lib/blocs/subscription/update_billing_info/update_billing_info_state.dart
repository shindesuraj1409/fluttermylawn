part of 'update_billing_info_bloc.dart';

abstract class UpdateBillingInfoState extends Equatable {
  const UpdateBillingInfoState();

  @override
  List<Object> get props => [];
}

class UpdateBillingInfoInitial extends UpdateBillingInfoState {}

class UpdatingBillingInfo extends UpdateBillingInfoState {}

class UpdateBillingInfoError extends UpdateBillingInfoState {
  final String errorMessage;
  const UpdateBillingInfoError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class UpdateBillingInfoSuccess extends UpdateBillingInfoState {}
