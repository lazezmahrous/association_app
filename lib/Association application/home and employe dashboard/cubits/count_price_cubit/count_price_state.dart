part of 'count_price_cubit.dart';


@immutable

sealed class CountPriceState {}


final class CountPriceInitial extends CountPriceState {}


final class CountPriceLoading extends CountPriceState {}


final class CountPriceSuccess extends CountPriceState {

  final double price;
  CountPriceSuccess({required this.price});

}


final class CountPriceFailure extends CountPriceState {}

