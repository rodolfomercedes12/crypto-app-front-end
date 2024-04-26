

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:crypto_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:crypto_app/features/shared/shared.dart';


  final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>((ref) {
    final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(
    registerUserCallback: registerUserCallback
  ); 
});


class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback
  }): super( RegisterFormState() );

  onEmailChange(String value){
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ newEmail, state.password ])
    );
  }

  onPasswordChange(String value){
     
     final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ newPassword, state.email ])
    );

  }

  onFormSubmit() async{
    _touchEveryField();
    if( !state.isValid ) return;
    state = state.copyWith( isPosting: true);
    
    await registerUserCallback( state.email.value, state.password.value );

    state = state.copyWith( isPosting: false);
  }

  _touchEveryField(){
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith( 
      isFormPosted: true,
       email: email,
        password: password, 
        isValid: Formz.validate([ email, password ])  );

  }

  
}


class RegisterFormState {


  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  RegisterFormState({ 
    this.isPosting =false,
    this.isFormPosted = false,
    this.isValid =false,
    this.email = const Email.pure(),
    this.password = const Password.pure()
     });

     @override
  String toString() {
    return ''' 
        RegisterFormState:
        isPosting: $isPosting
        isForPosted: $isFormPosted
        isValid: $isValid
        Email: $email
        Password: $password
    ''' ;
  }

  RegisterFormState copyWith ({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password
  }) => RegisterFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password
  );


}






