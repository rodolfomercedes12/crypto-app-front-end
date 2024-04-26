



import 'package:crypto_app/features/auth/domain/domain.dart';
import 'package:crypto_app/features/auth/infrastructure/infrastructure.dart';



class AuthRepositoryImpl extends AuthRepository {

  final AuthDataSource datasource;

  AuthRepositoryImpl({
    AuthDataSource? datasource
  }): datasource = datasource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<User> register(String email, String password) {
   return datasource.register(email, password);
  }

}