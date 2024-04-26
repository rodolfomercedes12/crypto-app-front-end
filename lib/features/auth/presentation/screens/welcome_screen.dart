import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/custom_filled_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          const Text("Welcome!", style: TextStyle( fontSize: 50, fontWeight: FontWeight.bold )),
          
          const SizedBox(height: 40,),
          
          Image.asset("assets/images/crypto-img.png", fit: BoxFit.cover, width: 200, height: 200,),
          
          const SizedBox(height: 30,),
          
         
          
           SizedBox(
            width: double.infinity,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomFilledButton(
                text: 'Login',
                buttonColor: Colors.black,
                onPressed: (){
                  context.push("/login");
                }
              ),
            )
          ),
          const SizedBox(height: 15,),
          const Text("Or", style: TextStyle( fontSize: 20, fontWeight: FontWeight.normal, letterSpacing: 0.8 )),
          const SizedBox(height: 15,),

           SizedBox(
            width: double.infinity,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomFilledButton(
                text: 'Register',
                buttonColor: Colors.black,
                onPressed: (){
                  context.push("/register");
                }
              ),
            )
          ),

        ],
      ),
    );
  }
}