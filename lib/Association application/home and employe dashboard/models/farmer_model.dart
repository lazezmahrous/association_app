import 'package:hive/hive.dart';

part 'farmer_model.g.dart';

@HiveType(typeId: 0)
class FarmerModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phoneNumber;
  @HiveField(3)
  final String amount;
  @HiveField(4)
  final String amountCategory;
  @HiveField(5)
  final double amountPaid;
  @HiveField(6)
  final String publisher;
  @HiveField(7)
  final DateTime dataPublisher;
  String? employeAssociation;
  String? employeCenterName;
  FarmerModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.amount,
    required this.amountCategory,
    required this.amountPaid,
    required this.publisher,
    required this.dataPublisher,
    this.employeAssociation,
    this.employeCenterName,
  });

  Map<String, dynamic> toJson() => {
        "username": name,
        "phoneNumber": phoneNumber,
        "amount": amount,
        "amountCategory": amountCategory,
        "amountPaid": amountPaid,
        "publisher": publisher,
        "dataPublisher": dataPublisher,
        "employeAssociation": employeAssociation,
        "employeCenterName": employeCenterName,
      };
}
