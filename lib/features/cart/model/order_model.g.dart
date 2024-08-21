// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 1;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      frameId: fields[0] as String,
      priceId: fields[1] as String,
      frameColor: fields[2] as String,
      quantity: fields[3] as int,
      name: fields[4] as String,
      price: fields[5] as String,
      isBordered: fields[6] as bool,
      selectedSize: fields[7] as String,
      image: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.frameId)
      ..writeByte(1)
      ..write(obj.priceId)
      ..writeByte(2)
      ..write(obj.frameColor)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.isBordered)
      ..writeByte(7)
      ..write(obj.selectedSize)
      ..writeByte(8)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
