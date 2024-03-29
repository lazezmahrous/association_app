part of 'mony_cubit.dart';

@immutable
sealed class MonyState {}

final class MonyInitial extends MonyState {}

final class GetMonyeLoading extends MonyState {}

final class GetMonyeSuccess extends MonyState {
  final double money;

  GetMonyeSuccess({required this.money});
}

final class GetMonyeFailure extends MonyState {
  final String errMessage;

  GetMonyeFailure({required this.errMessage});
}

final class DecreaseMonyeLoading extends MonyState {}

final class DecreaseMonyeSuccess extends MonyState {
  final double newMoney;

  DecreaseMonyeSuccess({required this.newMoney});
}

final class DecreaseMonyeFailure extends MonyState {
  final String errMessage;

  DecreaseMonyeFailure({required this.errMessage});
}
