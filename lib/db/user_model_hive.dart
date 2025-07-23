import 'package:hive/hive.dart';

import '../constants/hive_type_ids.dart';
import '../constants/user_model_field_ids.dart';

part 'user_model_hive.g.dart';

@HiveType(typeId: HiveTypeIds.userModelHive)
class UserModelHive extends HiveObject {
  @HiveField(UserModelFieldIds.id)
  int? id;

  @HiveField(UserModelFieldIds.name)
  String name;

  @HiveField(UserModelFieldIds.email)
  String email;

  @HiveField(UserModelFieldIds.password)
  String password;

  @HiveField(UserModelFieldIds.imagePath)
  String? imagePath;

  UserModelHive({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.imagePath,
  });

  UserModelHive copyWith({
    int? id,
    String? email,
    String? password,
    String? name,
    String? imagePath,
  }) {
    return UserModelHive(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
