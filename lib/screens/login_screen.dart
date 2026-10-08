import 'package:flutter/material.dart';

import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username == 'admin' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username atau password salah.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.storefront_rounded,
                      size: 42,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'SmartRetail POS',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Sistem Penjualan & Pemesanan Ritel',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),

                  const SizedBox(height: 40),

                  TextField(
                    controller: usernameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Masukkan username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    onSubmitted: (_) => login(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Masukkan password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: login,
                      child: const Text(
                        'MASUK',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Demo Login: admin / 1234',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
