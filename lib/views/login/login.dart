import 'dart:async';
import 'package:car_black_box/views/login/register_screen.dart';
import 'package:flutter/material.dart';
import '../../services/firebase_auth.dart';
import '../../services/get_it.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool enabled = true;
  int currentSeconds = 120;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Image.asset(
                          'assets/logo.png',
                          height: 200,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    // Hero(
                    //     tag: 'text',
                    //     child: Text(
                    //       'Keeper',
                    //       style: Theme.of(context).textTheme.headlineLarge,
                    //     )),
                    TextFormField(
                      controller: emailController,
                      validator: (email) => emailValidator(email),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (password) => passwordValidator(password),
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: Builder(builder: (context) {
                        if (enabled) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    forgetPassword(context);
                                  },
                                  child: const Text('Forgot Password?')),
                            ],
                          );
                        }
                        return Card(
                          margin: const EdgeInsets.only(top: 20),
                          color: Colors.greenAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Email Sent Successfully. \nTo : ${emailController.text.trim()}\nTry again in $currentSeconds seconds',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 40),
                    Hero(
                      tag: 'button',
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              bool errorMessage = false;
                              await getIt<FirebaseAuthRepo>()
                                  .signInWithEmailAndPassword(
                                      emailController.text.trim(),
                                      passwordController.text.trim())
                                  .catchError((error) {
                                errorMessage = true;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(error.toString())));}
                              );
                              if(!errorMessage){Navigator.pop(context);}
                            }
                          },
                          icon: const Icon(Icons.account_circle_rounded),
                          label: const Text('Login'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterScreen()));
                          },
                          child: const Text('Register'))
                    ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  emailValidator(String? email) {
    if (email == null) {
      return 'Please enter your email';
    }
    if (email.isEmpty) {
      return 'Please enter your email';
    }
    if (!email.contains('@')) {
      return 'Please enter a valid email';
    }
    if (email.length < 5) {
      return 'Please enter a valid email';
    }
    return null;
  }

  passwordValidator(String? pass) {
    if (pass == null) {
      return 'Password is required';
    }
    if (pass.isEmpty) {
      return 'Password is required';
    }
    if (pass.length < 6) {
      return 'password must be at least 6 characters';
    }
    return null;
  }

  forgetPassword(context) async {
    if (emailValidator(emailController.text.trim()) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email.')));
      return;
    }
    bool errorFlag = false;
    await getIt<FirebaseAuthRepo>()
        .forgotPassword(emailController.text.trim())
        .catchError((error) {
      errorFlag = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }).onError((e, s) {});
    if (!errorFlag) {
      showCard();
    }
  }

  showCard() {
    setState(() {
      enabled = false;
      currentSeconds = 120;
      timer = Timer.periodic(const Duration(seconds: 1), (callback) {
        currentSeconds -= 1;
        if (currentSeconds <= 0) {
          enabled = true;
          timer!.cancel();
        }
        setState(() {});
      });
    });
  }
}
