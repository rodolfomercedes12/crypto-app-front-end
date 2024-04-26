

import 'package:crypto_app/features/auth/domain/domain.dart';

class UserMapper {

  static User userJsonToEntity( Map<String, dynamic> json ) => User(
    uid: json["uid"],
     email: json["email"],
      password: json["password"],
     
       );

}