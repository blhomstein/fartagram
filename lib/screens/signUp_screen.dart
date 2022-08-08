import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/logic/auth_service.dart';
import 'package:social_media/responsive/mobile_screen_layout.dart';
import 'package:social_media/responsive/responsive_layout_screen.dart';
import 'package:social_media/screens/login_screen.dart';
import 'package:social_media/widgets/text_field_input.dart';

import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/urils.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => LoginScreen())));
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    debugPrint(image.toString());
    setState(() {
      _image = image;
    });
  }

  void signingUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String? response = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      userName: _userNameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    debugPrint(_isLoading.toString());
    setState(() {
      _isLoading = false;
    });
    if (response != "success") {
      showSnackBar(context, response!);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webscreenLayout: WebScreenLayout(),
              mobilescreenLayout: MobileScreenLayout())));
    }

    debugPrint(_isLoading.toString());
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
                      size: 80,
                      color: blueColor,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'fartageram',
                      style: GoogleFonts.bigShouldersStencilDisplay(
                        textStyle: const TextStyle(
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
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              "https://media.istockphoto.com/photos/silhouette-of-the-man-on-a-white-background-picture-id495585527?b=1&k=20&m=495585527&s=170667a&w=0&h=-GSnRR3Wkh_KYnEs8Yb2TYktZxS6lMkHiA2_YPufdPo=")),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              // text field input for email
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              TextFieldInput(
                textEditingController: _userNameController,
                hintText: 'enter your user name',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 25,
              ),
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'enter your bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 25,
              ),
              //text field input for password
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 25,
              ),
              //button for login
              InkWell(
                onTap: signingUpUser,
                child: Container(
                  child: _isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('SIGN-UP'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const ShapeDecoration(
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
                    child: Text("already have an account ? "),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: Text(
                        " login",
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
