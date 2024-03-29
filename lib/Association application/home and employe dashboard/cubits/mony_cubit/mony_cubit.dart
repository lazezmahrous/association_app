import 'package:bloc/bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:meta/meta.dart';

part 'mony_state.dart';

class MonyCubit extends Cubit<MonyState> {
  MonyCubit() : super(MonyInitial());

  Future<double?> getMoney(
      {required String employeCenterName,
      required String employeAssociation}) async {
    emit(GetMonyeLoading());

    try {
      DocumentSnapshot<Map<String, dynamic>> amount = await FirebaseFirestore
          .instance
          .collection(employeCenterName)
          .doc(employeAssociation)
          .get();

      String money = ((amount as dynamic)['money']).toString();
      print('amount : ${(amount as dynamic)['money']}');

      emit(GetMonyeSuccess(money: double.parse(money)));

      return double.parse(money);
    } catch (e) {
      print('error : ${e.toString()}');

      emit(GetMonyeFailure(errMessage: e.toString()));

      return 0.0;
    }
  }

  Future<double?> decreasePrice({
    required int decreaseMony,
    required String employeCenterName,
    required String employeAssociation,
    required String reason,
    required String employeName,
  }) async {
    emit(DecreaseMonyeLoading());

    await getMoney(
      employeCenterName: employeCenterName,
      employeAssociation: employeAssociation,
    ).then((value) async {
      if (value! == 0) {
        emit(DecreaseMonyeFailure(errMessage: 'حدث خطأ'));

        return 0;
      } else if (value < decreaseMony) {
        emit(DecreaseMonyeFailure(
            errMessage: 'المبلغ المسحوب أكبر من المبلغ الأساسي'));

        return 1;
      } else {
        double newMoney = value - decreaseMony.toDouble();

        print('ssssssssssssssss$value');

        print('ssssssssssssssss$decreaseMony');

        print('ssssssssssssssss$newMoney');

        try {
          await FirebaseFirestore.instance
              .collection(employeCenterName)
              .doc(employeAssociation)
              .update({
            "money": newMoney,
          });

          await FirebaseFirestore.instance
              .collection(employeCenterName)
              .doc(employeAssociation)
              .collection('withdrawals')
              .doc()
              .set({
            "amount": decreaseMony,
            "reason": reason,
            "employeName": employeName,
            "dataPublished": DateTime.now(),
          });

          emit(DecreaseMonyeSuccess(newMoney: newMoney.toDouble()));
        } catch (e) {
          emit(DecreaseMonyeFailure(errMessage: e.toString()));

          print(e.toString());
        }
      }
    });

    return await getMoney(
      employeCenterName: employeCenterName,
      employeAssociation: employeAssociation,
    );
  }
}
