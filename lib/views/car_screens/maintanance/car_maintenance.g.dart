// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_maintenance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarMaintenanceAdapter extends TypeAdapter<CarMaintenance> {
  @override
  final int typeId = 3;

  @override
  CarMaintenance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CarMaintenance(
      lastBatteryCheck: fields[0] as DateTime?,
      nextBatteryCheck: fields[1] as DateTime?,
      lastOilChange: fields[2] as DateTime?,
      nextOilChange: fields[3] as DateTime?,
      lastTireCheck: fields[4] as DateTime?,
      nextTireCheck: fields[5] as DateTime?,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CarMaintenance obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.lastBatteryCheck)
      ..writeByte(1)
      ..write(obj.nextBatteryCheck)
      ..writeByte(2)
      ..write(obj.lastOilChange)
      ..writeByte(3)
      ..write(obj.nextOilChange)
      ..writeByte(4)
      ..write(obj.lastTireCheck)
      ..writeByte(5)
      ..write(obj.nextTireCheck)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarMaintenanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
