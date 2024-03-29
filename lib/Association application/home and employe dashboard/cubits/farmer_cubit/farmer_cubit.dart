import 'package:bloc/bloc.dart';


import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:hessen_app/constanc.dart';


import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/models/farmer_model.dart';


import 'package:hive/hive.dart';


import 'package:meta/meta.dart';


import 'package:uuid/uuid.dart';


part 'farmer_state.dart';


class FarmerCubit extends Cubit<FarmerState> {

  var farmersBox = Hive.box<FarmerModel>(Constanc.kFarmersBox);


  FarmerCubit() : super(FarmerInitial());


  Future<void> getFarmers() async {

    emit(GetFarmersSuccess(farmers: farmersBox.values.toList()));

  }


  Future addFarmer({

    required FarmerModel farmer,

    required String farmerAmountUnit,

  }) async {

    emit(AddFarmerLoading());


    try {

      var uuid = const Uuid();


      farmersBox.add(farmer);


      print(uuid.v4());


      await Future.delayed(const Duration(seconds: 3));


      await FirebaseFirestore.instance

          .collection('farmers')

          .doc(uuid.v4())

          .set({

        "username": farmer.name,

        "phoneNumber": farmer.phoneNumber,

        "amount": '${farmer.amount} $farmerAmountUnit',

        "amountCategory": farmer.amountCategory,

        "amountPaid": farmer.amountPaid,

        "publisher": farmer.publisher,

        "dataPublisher": farmer.dataPublisher,

        "employeAssociation": farmer.employeAssociation,

        "employeCenterName": farmer.employeCenterName,

      });


      emit(AddFarmerSuccess());

    } catch (e) {

      emit(

        AddFarmerFailure(

          errMessage: e.toString(),

        ),

      );

    }

  }


  Future<void> checkItemAmount({

    required String employeAssociation,

    required String employeCenterName,

    required String category,

    required String amount,

  }) async {

    print(employeAssociation);


    print(employeCenterName);


    print(category);


    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore

        .instance

        .collection(employeCenterName)

        .doc(employeAssociation)

        .collection('items')

        .doc(category)

        .get();


    print(data.data()!['amount']);


    final Map<String, dynamic> dataMap = data.data() as Map<String, dynamic>;


    final String amountString = dataMap['amount'] as String;


    double farmerAmount = double.parse(amount.split(" ")[1]);


    if (amountString.isNotEmpty) {

      final List<String> splitted = amountString.split(" ");


      if (splitted.length == 2) {

        final double orignalAmount = double.parse(splitted[0]);


        final orignalUnit = splitted[1].trim();


        print('unit : $orignalUnit');


        print('number : $orignalAmount');


        print('amount :  $amount');


        print('farmerAmount :  $farmerAmount');


        if (orignalAmount <= 0) {

          emit(ChechAmountFailure(errMessage: 'تم إنتهاء الكمية'));

        } else {

          if (amount.contains('كيلو')) {

            if (orignalUnit == "طن" && farmerAmount <= 1000) {

              double keloUnit = orignalAmount * 1000.0;


              // double farmerAmountUnit = farmerAmount * 1000.0;


              double newAmount = keloUnit - farmerAmount;


              print('kelooUnit : $keloUnit');


              print('keloo : $newAmount');


              await FirebaseFirestore.instance

                  .collection(employeCenterName)

                  .doc(employeAssociation)

                  .collection('items')

                  .doc(category)

                  .update({

                'amount': '${newAmount / 1000} $orignalUnit',

              });


              emit(ChechAmountSuccess());

            } else if (orignalUnit == "كيلو" && farmerAmount <= orignalAmount) {

              double newAmount = orignalAmount - farmerAmount;


              print('kelooUnit : $newAmount');


              await FirebaseFirestore.instance

                  .collection(employeCenterName)

                  .doc(employeAssociation)

                  .collection('items')

                  .doc(category)

                  .update({

                'amount': '${newAmount / 1000} $orignalUnit',

              });


              emit(ChechAmountSuccess());

            } else {

              emit(ChechAmountFailure(errMessage: 'كمية غير متوفره'));

            }

          } else if (amount.contains('طن')) {

            if (orignalUnit == "كيلو") {

              emit(ChechAmountFailure(errMessage: 'كمية غير متوفره'));

            } else if (orignalUnit == 'طن' && farmerAmount <= orignalAmount) {

              double newAmount = orignalAmount - farmerAmount;


              print('kelooUnit : $newAmount');


              await FirebaseFirestore.instance

                  .collection(employeCenterName)

                  .doc(employeAssociation)

                  .collection('items')

                  .doc(category)

                  .update({

                'amount': '${newAmount / 1000} $orignalUnit',

              });


              emit(ChechAmountSuccess());

            } else {

              emit(ChechAmountFailure(errMessage: 'كمية غير متوفره'));

            }

          }

        }

      } else if (splitted.length == 1) {

        emit(ChechAmountFailure(errMessage: 'تم إنتهاء الكمية'));

      } else {

        emit(ChechAmountFailure(

            errMessage: 'تم تسجيل الكميه بشكل خطا علي السيستم'));

      }

    }

  }

}

