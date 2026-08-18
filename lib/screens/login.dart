import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../service/bio_metrics_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final BiometricService biometricService = BiometricService();

  bool isAuthenticated = false;
  bool isProcessing = true;

  @override
  void initState() {
    super.initState();
    authenticateUser();
  }

  Future<void> authenticateUser() async {
    final result = await biometricService.authenticate();

    if (!mounted) return;

    setState(() {
      isAuthenticated = result;
      isProcessing = false;
      if (isAuthenticated) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isProcessing)
              const Text(
                "Login Processing...",
                style: TextStyle(
                  fontSize: 30,
                ),
              )
            else
              if (isAuthenticated)
                const Text(
                  "Login Successful",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                )
              else
                Column(
                  children: [
                    const Text(
                      "Use Biometrics to Login",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          authenticateUser();
                        },
                        child: Icon(Icons.lock,
                          size: 20,)
                    )
                  ],
                ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}