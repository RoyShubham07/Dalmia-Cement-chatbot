import 'package:flutter/material.dart';
import 'package:healthsphere/pages/login_page.dart';
import 'package:healthsphere/pages/main/ai_bot_page.dart';
class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Dalmia Cement',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
              ElevatedButton(
                onPressed: () {
                  // Add button press logic here
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AIBotScreen()),
            );
            
                },
                 style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow, 
            ),

                child: const Text('Get Started',style: TextStyle(color: Colors.black)),
                
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // Add button press logic here
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
                },
                style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow, 
            ),
                child: const Text('Log Out',style: TextStyle(color: Colors.black)),
              ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
