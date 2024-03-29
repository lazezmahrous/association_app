import 'package:bloc/bloc.dart';


import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:firebase_auth/firebase_auth.dart';


import 'package:hessen_app/Association%20application/login%20and%20register/models/employe_signup_model.dart';


import 'package:meta/meta.dart';


import '../../../login and register/models/employe_signup_model.dart' as model;


part 'employe_state.dart';


class EmployeCubit extends Cubit<EmployeState> {

  EmployeCubit() : super(EmployeInitial());


  Future<void> getEmployeDetails() async {

    emit(GetEmployeLoading());


    try {

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =

          await FirebaseFirestore.instance

              .collection('employees')

              .doc(FirebaseAuth.instance.currentUser!.uid)

              .get();


      print(documentSnapshot);


      emit(

        GetEmployeSuccess(

            user: model.EmployeSighnUpModel.fromSnap(documentSnapshot)),

      );

    } catch (e) {
      
      emit(

        GetEmployeFailure(

          errMessage: e.toString(),

        ),

      );

    }

  }

  
}

