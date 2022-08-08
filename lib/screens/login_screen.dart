import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/logic/auth_service.dart';
import 'package:social_media/screens/signUp_screen.dart';
import 'package:social_media/utils/urils.dart';
import 'package:social_media/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => SignUpScreen())));
  }

  void loginInUser() async {
    setState(() {
      isLoading = true;
    });
    String response = await AuthMethods().loginUser(
        email: emailController.text, password: passwordController.text);
    if (response == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webscreenLayout: WebScreenLayout(),
              mobilescreenLayout: MobileScreenLayout())));
    } else {
      showSnackBar(context, response);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              // asvg image for the logo
              Container(
                child: Column(
                  children: [
                    const Icon(
                      Icons.animation,
                      size: 150,
                      color: blueColor,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'fartageram',
                      style: GoogleFonts.bigShouldersStencilDisplay(
                        textStyle: TextStyle(
                            fontSize: 35,
                            letterSpacing: 5,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 64,
              ),

              // text field input for email
              TextFieldInput(
                textEditingController: emailController,
                hintText: 'enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 25,
              ),
              //text field input for password
              TextFieldInput(
                textEditingController: passwordController,
                hintText: 'enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              SizedBox(
                height: 25,
              ),
              //button for login
              InkWell(
                onTap: loginInUser,
                child: Container(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('LOG-IN'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      color: blueColor),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("dont have an account ? "),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      child: Text(
                        " sign up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ],
              )
              //transition to sign up

              //remember the password
            ],
          ),
        ),
      ),
    );
  }
}
