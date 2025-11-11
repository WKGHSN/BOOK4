

part of 'user.dart';



class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      photoUrl: fields[3] as String?,
      favoriteBooks: (fields[4] as List).cast<String>(),
      booksRead: fields[5] as int,
      favoriteGenres: (fields[6] as List).cast<String>(),
      readBooks: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.favoriteBooks)
      ..writeByte(5)
      ..write(obj.booksRead)
      ..writeByte(6)
      ..write(obj.favoriteGenres)
      ..writeByte(7)
      ..write(obj.readBooks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
