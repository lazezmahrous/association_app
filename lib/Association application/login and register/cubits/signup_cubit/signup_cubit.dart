import 'package:bloc/bloc.dart';


import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:firebase_auth/firebase_auth.dart';


import 'package:hessen_app/Association%20application/login%20and%20register/models/employe_signup_model.dart';


import 'package:meta/meta.dart';


import 'package:shared_preferences/shared_preferences.dart';


import '../../models/employe_signup_model.dart' as model;


part 'signup_state.dart';


class SignUpCubit extends Cubit<SignupState> {

  SignUpCubit() : super(SignupInitial());


  Future sighnUpEmploaye({required EmployeSighnUpModel employe}) async {

    emit(SignupLoading());


    try {

      UserCredential userCred =

          await FirebaseAuth.instance.createUserWithEmailAndPassword(

        email: employe.employeEmail,

        password: employe.employePassword,

      );


      if (userCred.user!.uid.isNotEmpty) {

        model.EmployeSighnUpModel(

          employeCenterName: employe.employeCenterName,

          employeAssociation: employe.employeAssociation,

          employeEmail: employe.employeEmail,

          employeName: employe.employeName,

          employePassword: employe.employePassword,

          employePhoneNumber: employe.employePhoneNumber,

        );


        final SharedPreferences prefs = await SharedPreferences.getInstance();


        prefs.setString('employeName', employe.employeName);


        prefs.setString('employeAssociation', employe.employeAssociation);


        await FirebaseFirestore.instance

            .collection('employees')

            .doc(userCred.user!.uid)

            .set(

          {

            "employeName": employe.employeName,

            "employeCenterName": employe.employeCenterName,

            "employeAssociation": employe.employeAssociation,

            "employePhoneNumber": employe.employePhoneNumber,

            "employeEmail": employe.employeEmail,

            "employePassword": employe.employePassword,

          },

        );

      }


      emit(SignupSuccess());

    } on FirebaseAuthException catch (e) {

      print(e.code);


      emit(SignupFailure(erMessage: e.toString()));

    }

  }

}

