import 'package:flutter/material.dart';
import 'package:task_manager/presentation/screens/Auth/sing_in_screen.dart';

import 'package:task_manager/presentation/widgets/background_widget.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController confirmpasswordTEController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100.0),
                  Text('Set Password',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4.0),
                  const Text(
                    "Minimum length password 8 charecter with Latter and number combination",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  TextFormField(
                    controller: passwordTEController,
                    decoration: const InputDecoration(hintText: 'password'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmpasswordTEController,
                    decoration:
                        const InputDecoration(hintText: 'confirom password'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SingInScreen(),
                            ),
                            (route) => false);
                      },
                      child: const Text("Confirom"),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an Account?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SingInScreen(),
                              ),
                              (route) => false);
                        },
                        child: const Text('Sing In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    passwordTEController.dispose();
    confirmpasswordTEController.dispose();

    super.dispose();
  }
}
