import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty_machine_test/screens/authentication_screens/forgot_password.dart';
import 'package:tentwenty_machine_test/screens/authentication_screens/signup_screen.dart';
import 'package:tentwenty_machine_test/widgets/common_widgets.dart';

import '../../models/request_models.dart';
import '../../providers/auth_provider.dart';
import '../../utils/extensions_and_validators.dart';
import '../feature_screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DateTime? currentBackPressTime;

  final snackBar = const SnackBar(
    content: Text('Press back again to leave'),
    duration: Duration(seconds: 2),
  );

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).primaryColor,
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: size.height * 0.25,
                    alignment: Alignment.center,
                    child: PoppinsText(
                      data: 'OOPACKS',
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(80),
                          ),
                          color: Theme.of(context).colorScheme.secondary),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.06,
                          ),
                          PoppinsText(
                            data: 'Login',
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          TextFormWidget(
                            textFormTitle: 'Email',
                            hintText: hintEmail,
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            obscureText: false,
                            validator: (input) => input!.validateEmail(input),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          TextFormWidget(
                            textFormTitle: 'Password',
                            hintText: hintPassword,
                            controller: passwordController,
                            inputType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) =>
                                value!.validatePassword(value),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) =>
                                      const ForgotPasswordScreen(),
                                ),
                              ),
                              child: const PoppinsText(
                                data: 'Forgot Password?',
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          ElevatedButton(
                            onPressed: handleLogin,
                            style: ElevatedButton.styleFrom(
                              fixedSize:
                                  Size(size.width * 0.85, size.width * 0.14),
                            ),
                            child: PoppinsText(
                              data: 'Login',
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.secondary,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PoppinsText(
                          data: "Don't have any account?",
                          color: Theme.of(context).primaryColor,
                        ),
                        TextButton(
                          onPressed: () {

                            Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (builder) => const SignUpScreen(),
                            ),
                          );
                            _formKey.currentState!.reset();
                          },
                          child: const PoppinsText(
                            data: 'Sign Up',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleLogin() async {
    if (_formKey.currentState!.validate()) {
      debugPrint('TextFieldsAreValidated SUCCESSFULLY');
      AuthProvider authProvider =
          Provider.of<AuthProvider>(context, listen: false);

      // Example Login
      LoginRequest loginRequest = LoginRequest(
        emailOrPhoneNumber: emailController.text,
        password: passwordController.text,
      );
      bool loginSuccess =
          await authProvider.loginUser(loginRequest: loginRequest);
      debugPrint('LoginSuccessHandler $loginSuccess');
      if (loginSuccess) {
        // Navigate to home page or perform other actions upon successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          emailController.clear();
          passwordController.clear();
          _formKey.currentState?.reset();
        });
        showCustomSnackBar(
            context: context,
            message: 'Authentication Failed',
            success: false,
            textColor: Colors.white,
            duration: const Duration(seconds: 2));
      }
    }
  }
}

class TextFormWidget extends StatelessWidget {
  final String textFormTitle;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? hintText;

  const TextFormWidget(
      {Key? key,
      required this.textFormTitle,
      required this.controller,
      required this.inputType,
      required this.obscureText,
      this.validator,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.23,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PoppinsText(
            data: textFormTitle,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: TextStyle(color: Colors.grey.shade700),
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: obscureText,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  border: fieldBorder,
                  hintText: hintText,
                  hintStyle:
                      GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                  // contentPadding: EdgeInsets.zero,
                  enabledBorder: fieldBorder,
                  focusedBorder: fieldBorder,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none),
              inputFormatters: inputType != TextInputType.visiblePassword
                  ? [
                      FilteringTextInputFormatter.deny(
                        RegExp(r'[^a-zA-Z0-9@._]'),
                      ),
                    ]
                  : null,
              keyboardType: inputType,
              validator: validator,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          )
        ],
      ),
    );
  }

  final fieldBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  );

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );

    return emailRegex.hasMatch(email);
  }
}
