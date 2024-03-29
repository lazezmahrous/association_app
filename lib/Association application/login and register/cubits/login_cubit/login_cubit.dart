import 'package:bloc/bloc.dart';


import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:firebase_auth/firebase_auth.dart';


import 'package:hessen_app/Association%20application/login%20and%20register/models/employe_login_model.dart';


import 'package:meta/meta.dart';


part 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {

  LoginCubit() : super(LoginInitial());


  Future loginUser({required String email, required String password}) async {

    emit(LoginLoading());


    try {

      await FirebaseAuth.instance

          .signInWithEmailAndPassword(email: email, password: password);


      emit(LoginSuccess());

    } on FirebaseAuthException catch (e) {

      print('error ${e.code}');


      emit(LoginFailure(erMessage: e.code));

    }

  }

}

