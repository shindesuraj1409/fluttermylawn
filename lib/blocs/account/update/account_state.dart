part of 'account_bloc.dart';

enum AccountStatus {
  initial,
  loading,
  success,
  error,
}

class AccountState extends Equatable {
  final AccountStatus status;
  final String errorMessage;
  final String successMessage;
  final User user;

  AccountState.initial(User user)
      : status = AccountStatus.initial,
        errorMessage = null,
        successMessage = null,
        user = user;

  AccountState.loading(User user)
      : status = AccountStatus.loading,
        errorMessage = null,
        successMessage = null,
        user = user;

  AccountState.success(String successMessage, User user)
      : status = AccountStatus.success,
        errorMessage = null,
        successMessage = successMessage,
        user = user;

  AccountState.error(String errorMessage, User user)
      : status = AccountStatus.error,
        errorMessage = errorMessage,
        successMessage = null,
        user = user;

  @override
  List<Object> get props => [
        status,
        errorMessage,
        successMessage,
      ];
}
