import 'package:crypto_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crypto_app/config/router/app_router_notifier.dart';
import 'package:crypto_app/features/auth/auth.dart';
import 'package:crypto_app/features/auth/presentation/providers/auth_provider.dart';
import '../../features/crypto/presentation/screens/home_screen.dart';



final goRouterProvider = Provider((ref) {

  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
  initialLocation: '/welcome',
  refreshListenable: goRouterNotifier,
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const CheckAuthStatusScreen(),
    ),

    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),

    ///* Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ///* Crypto Routes
    GoRoute(
      path: '/',
      builder: (context, state) =>  const CryptoChart(),
    ),

    
  ],
 
  redirect: (context, state) {
    
    final isGoingTo = state.subloc;
    final authStatus = goRouterNotifier.authStatus;

    print(authStatus);

    if( isGoingTo == "/splash" && authStatus == AuthStatus.checking ) return null;
    if(  authStatus == AuthStatus.notAuthenticated ){
      if( isGoingTo == "/login" || isGoingTo == "/register" ) return null;
      return "/welcome";
    }

    if( authStatus == AuthStatus.authenticated ){
      if( isGoingTo == "/login" || isGoingTo == "/register" || isGoingTo == "/splash" ) return "/";
    }

    

    return null;

  },
);

}  );

