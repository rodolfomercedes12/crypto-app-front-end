
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_app/features/auth/domain/domain.dart';
import 'package:crypto_app/features/auth/infrastructure/infrastructure.dart';
import 'package:crypto_app/features/shared/infrastructure/services/key_value_storage.dart';
import 'package:crypto_app/features/shared/infrastructure/services/key_value_storage_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();
  final keyValueStorage = KeyValueStorageImpl();
  

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorage: keyValueStorage
  );
});



class AuthNotifier extends StateNotifier<AuthState> {
  final  AuthRepository authRepository;
  final KeyValueStorage keyValueStorage;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorage
  }): super(AuthState()){
    checkAuthStatus();
  }

  Future<void> loginUser( String email, String password ) async {
    await Future.delayed( const Duration(milliseconds: 500) );
    try {
      final user = await authRepository.login(email, password);
      print(user);
      _setLoggedUser(user);
      
    } on CustomError catch (e) {
      print("CustomError en el provider!!!!!!!! ${e.message}");

      logout(e.message);
    } catch (e) {
      
      logout("Error no controlado");
    }
  }

   void registerUser( String email, String password ) async {
    try {
      final user = await authRepository.register(email, password);
      print(user);
      _setLoggedUser(user);
      
    } on CustomError catch (e) {
      print("CustomError en el provider!!!!!!!! ${e.message}");

      logout(e.message);
    } catch (e) {
      
      logout("Error no controlado");
    }
  }

   void checkAuthStatus() async {
    
    final token = await keyValueStorage.getValue<String>("token");

    if( token == null ) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }

  }

  void _setLoggedUser(User user) async {
   //await  keyValueStorage.setKeyValue("token", user.token );
    state = state.copyWith(
       user: user,
       authStatus: AuthStatus.authenticated,
       errorMessage: "",
        );
  }

  Future<void> logout([ String? errorMessage ]) async {

    await  keyValueStorage.removeKey("token");

   state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage
    );
  }
  
}

enum AuthStatus{ checking, authenticated, notAuthenticated }

class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user, 
    this.errorMessage = ""
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage
  }) => AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage
  );

}