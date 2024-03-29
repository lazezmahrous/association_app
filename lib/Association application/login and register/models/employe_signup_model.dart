import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeSighnUpModel {
  final String employeName;
  final String employePhoneNumber;
  final String employeEmail;
  final String employePassword;
  final String employeCenterName;
  final String employeAssociation;

  EmployeSighnUpModel({
    required this.employeName,
    required this.employePhoneNumber,
    required this.employeEmail,
    required this.employePassword,
    required this.employeCenterName,
    required this.employeAssociation,
  });

  static EmployeSighnUpModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return EmployeSighnUpModel(
      employeCenterName: snapshot['employeCenterName'],
      employeAssociation: snapshot['employeAssociation'],
      employeEmail: snapshot['employeEmail'],
      employeName: snapshot['employeName'],
      employePassword: snapshot['employePassword'],
      employePhoneNumber: snapshot['employePhoneNumber'],
    );
  }
}
