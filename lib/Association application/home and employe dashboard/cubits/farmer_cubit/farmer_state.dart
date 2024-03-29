part of 'farmer_cubit.dart';


@immutable

sealed class FarmerState {}


final class FarmerInitial extends FarmerState {}


final class AddFarmerLoading extends FarmerState {}


final class AddFarmerSuccess extends FarmerState {}


final class AddFarmerFailure extends FarmerState {

  final String errMessage;


  AddFarmerFailure({required this.errMessage});

}


final class GetFarmersSuccess extends FarmerState {

  final List<FarmerModel> farmers;


  GetFarmersSuccess({required this.farmers});

}


final class ChechAmountSuccess extends FarmerState {

  ChechAmountSuccess();

}


final class ChechAmountFailure extends FarmerState {

  final String errMessage;

  ChechAmountFailure({required this.errMessage});

}

