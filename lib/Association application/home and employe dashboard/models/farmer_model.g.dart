// GENERATED CODE - DO NOT MODIFY BY HAND


part of 'farmer_model.dart';


// **************************************************************************

// TypeAdapterGenerator

// **************************************************************************


class FarmerModelAdapter extends TypeAdapter<FarmerModel> {

  @override

  final int typeId = 0;


  @override

  FarmerModel read(BinaryReader reader) {

    final numOfFields = reader.readByte();

    final fields = <int, dynamic>{

      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),

    };

    return FarmerModel(

      id: fields[0] as String,

      name: fields[1] as String,

      phoneNumber: fields[2] as String,

      amount: fields[3] as String,

      amountCategory: fields[4] as String,

      amountPaid: fields[5] as double,

      publisher: fields[6] as String,

      dataPublisher: fields[7] as DateTime,

    );

  }


  @override

  void write(BinaryWriter writer, FarmerModel obj) {

    writer

      ..writeByte(8)

      ..writeByte(0)

      ..write(obj.id)

      ..writeByte(1)

      ..write(obj.name)

      ..writeByte(2)

      ..write(obj.phoneNumber)

      ..writeByte(3)

      ..write(obj.amount)

      ..writeByte(4)

      ..write(obj.amountCategory)

      ..writeByte(5)

      ..write(obj.amountPaid)

      ..writeByte(6)

      ..write(obj.publisher)

      ..writeByte(7)

      ..write(obj.dataPublisher);

  }


  @override

  int get hashCode => typeId.hashCode;


  @override

  bool operator ==(Object other) =>

      identical(this, other) ||

      other is FarmerModelAdapter &&

          runtimeType == other.runtimeType &&

          typeId == other.typeId;

}

