// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_health.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarHealthAdapter extends TypeAdapter<CarHealth> {
  @override
  final int typeId = 2;

  @override
  CarHealth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarHealth(
      fields[0] as String,
      fields[1] as int,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CarHealth obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.bloodType)
      ..writeByte(3)
      ..write(obj.diseases)
      ..writeByte(4)
      ..write(obj.medications);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarHealthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
