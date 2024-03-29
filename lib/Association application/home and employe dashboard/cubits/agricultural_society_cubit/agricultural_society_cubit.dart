import 'package:bloc/bloc.dart';


import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:meta/meta.dart';


part 'agricultural_society_state.dart';


class AgriculturalSocietyCubit extends Cubit<AgriculturalSocietyState> {

  AgriculturalSocietyCubit() : super(AgriculturalSocietyInitial());


  Future<void> getData(

      {required String employeCenterName,

      required String employeAssociation}) async {

    emit(GetDataLoading());


    try {

      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore

          .instance

          .collection(employeCenterName)

          .doc(employeAssociation)

          .collection('items')

          .get();


      emit(GetDataSuccess(data: data));

    } catch (e) {

      print(e.toString());


      emit(

        GetDataFailure(

          errMessage: e.toString(),

        ),

      );

    }

  }

}

