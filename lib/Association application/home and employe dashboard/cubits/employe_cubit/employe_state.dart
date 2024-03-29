part of 'employe_cubit.dart';


@immutable

sealed class EmployeState {}


final class EmployeInitial extends EmployeState {}


final class GetEmployeLoading extends EmployeState {}


final class GetEmployeSuccess extends EmployeState {

  final EmployeSighnUpModel user;

  GetEmployeSuccess({required this.user});

}


final class GetEmployeFailure extends EmployeState {

  final String errMessage;


  GetEmployeFailure({required this.errMessage});

}

