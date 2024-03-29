import 'package:bloc/bloc.dart';


import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:meta/meta.dart';


part 'count_price_state.dart';


class CountPriceCubit extends Cubit<CountPriceState> {

  CountPriceCubit() : super(CountPriceFailure());


  Future<void> countPrice({

    required String farmerAmountUnit,

    required String employeCenterName,

    required String employeAssociation,

    required String farmerAmountCategory,

    required double farmerAmountPaid,

  }) async {

    if (farmerAmountUnit == 'كيلو') {

      var data = await FirebaseFirestore.instance

          .collection(employeCenterName)

          .doc(employeAssociation)

          .collection('items')

          .doc(farmerAmountCategory)

          .get();


      double price =
          farmerAmountPaid * (data as dynamic)['keloUnitPrice'].toDouble();


      emit(CountPriceSuccess(price: price));


      // farmerAmountPaid = price.toString();

    } else {}

  }

}

