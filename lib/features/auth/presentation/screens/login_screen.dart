import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:crypto_app/features/auth/presentation/providers/providers.dart';
import 'package:crypto_app/features/shared/shared.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          //physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox( height: 80 ),
              
            
              const SizedBox( height: 80 ),
    
              Container(
                height: size.height - 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                ),
                child: const _LoginForm(),
              )
            ],
          ),
        )
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  void showSnackbar( BuildContext context, String message ){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  @override
  Widget build(BuildContext context, ref) {

    final textStyles = Theme.of(context).textTheme;
    final loginForm = ref.watch(loginFormProvider);

    ref.listen( authProvider, (previous, next){
      if( next.errorMessage.isEmpty ) return;
      showSnackbar( context, next.errorMessage );
    } );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox( height: 50 ),
          Text('Login', style: textStyles.titleLarge ),
          const SizedBox(height: 25,),
          
          const SizedBox( height: 90 ),


           CustomTextFormField(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read( loginFormProvider.notifier ).onEmailChange,
            errorMessage: loginForm.isFormPosted ? loginForm.email.errorMessage : null,
          ),
          const SizedBox( height: 30 ),

           CustomTextFormField(
            label: 'Password',
            obscureText: true,
            onChanged: ref.read( loginFormProvider.notifier ).onPasswordChange,
            onFieldSubmitted: (_) => ref.read( loginFormProvider.notifier ).onFormSubmit(),
            errorMessage: loginForm.isFormPosted ? loginForm.password.errorMessage : null,
          ),
    
          const SizedBox( height: 30 ),

          
          
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Login',
              buttonColor: Colors.black,
              onPressed: loginForm.isPosting ? null 
              : ref.read( loginFormProvider.notifier).onFormSubmit 
            )
          ),

          const Spacer( flex: 2 ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Don´t have an account?'),
              TextButton(
                onPressed: ()=> context.push('/register'), 
                child: const Text('Register')
              )
            ],
          ),

          const Spacer( flex: 1),
        ],
      ),
    );
  }
}