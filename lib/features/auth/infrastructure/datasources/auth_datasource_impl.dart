

 import 'package:dio/dio.dart';
import 'package:crypto_app/config/config.dart';
import 'package:crypto_app/features/auth/domain/domain.dart';
import 'package:crypto_app/features/auth/infrastructure/infrastructure.dart';

class  AuthDataSourceImpl  extends AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    )
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try {

      final response = await dio.get( "/auth/check-status", options: Options(
        headers: {
          "Authorization": "Bearer $token"
        }
      ));
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
      
    } on DioError catch (e){
      if(e.response?.statusCode == 401) {
        throw CustomError("Token no válido");
      }
      throw Exception();
    } catch (e) {
      throw Exception();

    }
  }

  @override
  Future<User> login(String email, String password) async {

    try {
      final response = await dio.post("/api/login" /*"/auth/login"*/, data: {
        "email": email,
        "password": password
      } );


      final user = UserMapper.userJsonToEntity(response.data["usuario"]);
      return user;
    } on DioError catch (e){
      
      if(e.response?.statusCode == 404) {
        throw CustomError( e.response?.data["message"] ?? "Credenciales incorrectas" );
      }

       if( e.response?.statusCode == 400 ) {
        throw CustomError( e.response?.data["message"] ?? "Contraseña incorrecta" );
      }

     
     
      
      throw Exception();
    } catch (e) {
      throw CustomError( "Login Error" );

    }
  }
















  @override
  Future<User> register(String email, String password) async{
    try {
      final response = await dio.post("/api/login/new", data: {
        "email": email,
        "password": password
      } );


      final user = UserMapper.userJsonToEntity(response.data["usuario"]);
      return user;
    } on DioError catch (e){
      

       if( e.response?.statusCode == 400 ) {
        throw CustomError( e.response?.data["message"] ?? "El correo ya está registrado" );
      }

   
      
      throw Exception();
    } catch (e) {

      throw CustomError( "Register Error" );

    }
  }

  

}