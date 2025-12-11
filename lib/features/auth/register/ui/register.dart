import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/core/routes/routes.dart';
import 'package:face_book_clone/features/auth/login/ui/login.dart';
import 'package:face_book_clone/features/auth/register/data/register_cubit/cubit/auh_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController displayCon = TextEditingController();
  TextEditingController usernameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/svg/n_logo.svg',
                    height: 150,
                    width: 150,
                    //  color: kPrimaryColor,
                    colorFilter: ColorFilter.mode(
                      kPrimaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "06",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "16",
                      style: TextStyle(
                        fontSize: 26,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Gap(20),
                TextField(
                  controller: displayCon,
                  decoration: InputDecoration(
                    fillColor: kWhiteColor,
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                    hintText: "Display Name",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Gap(20),
                TextField(
                  controller: usernameCon,
                  decoration: InputDecoration(
                    fillColor: kWhiteColor,
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                    hintText: "Username",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Gap(20),
                TextField(
                  controller: emailCon,
                  decoration: InputDecoration(
                    fillColor: kWhiteColor,
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Gap(20),
                TextField(
                  controller: passwordCon,
                  obscureText: true,
                  decoration: InputDecoration(
                    fillColor: kWhiteColor,
                    filled: true,
                    prefixIcon: Icon(Icons.password),
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Gap(20),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is RegisterAuthenticated) {
                      // حالة نجاح التسجيل
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Success To Register User!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pushNamed(context, Routes.loginPage);
                    } else if (state is RegisterError) {
                      // حالة حدوث خطأ أثناء التسجيل
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kSeconderyColor,
                              padding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              // استدعاء دالة register من Cubit
                              context.read<AuthCubit>().register(
                                emailCon.text,
                                passwordCon.text,
                                usernameCon.text,
                                displayCon.text,
                              );
                            },
                            child: state is RegisterLoading
                                ? CircularProgressIndicator(color: kWhiteColor)
                                : Text(
                                    'Register'.toUpperCase(),
                                    style: TextStyle(color: kWhiteColor),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      ),
                      child: Text(
                        "login now",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
