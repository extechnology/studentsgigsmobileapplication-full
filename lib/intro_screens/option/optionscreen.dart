import 'package:anjalim/intro_screens/option/bloc/option_bloc.dart';
import 'package:anjalim/intro_screens/option/bloc/option_event.dart';
import 'package:anjalim/intro_screens/option/bloc/option_state.dart';
import 'package:anjalim/mainpage/registerpage/loginpageog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OptionBloc(),
      child: const OptionView(),
    );
  }
}

class OptionView extends StatelessWidget {
  const OptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      body: BlocListener<OptionBloc, OptionState>(
        listener: (context, state) {
          // Handle navigation based on state changes
          if (state is StudentSelected) {
            _navigateToLogin(context, 'student');
          } else if (state is EmployerSelected) {
            _navigateToLogin(context, 'employer');
          }
        },
        child: Stack(
          children: [
            /// Background Image (Positioned to be in the center)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Image.asset(
                  "lib/assets/images/onboard/image (2) 1.png",
                  fit: BoxFit.fill,
                  height: 227,
                  width: 227,
                ),
              ),
            ),

            /// Foreground Layout (Transparent Container)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white.withOpacity(0.8),
                child: Column(
                  children: [
                    /// Top Section (Welcome Text, Logo, Description)
                    Column(
                      children: [
                        const SizedBox(height: 90),
                        const Text(
                          "Welcome to",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xff000000),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Image.asset("lib/assets/images/logos/image 1.png"),
                        Padding(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Connecting students with the best gigs and companies with top student talent—quick, easy, and hassle-free! ",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1.1,
                                    height: 2,
                                  ),
                                ),
                                TextSpan(
                                  text: "🚀",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),

                    // Option Buttons with BLoC state management
                    BlocBuilder<OptionBloc, OptionState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Student Option Button
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 40, left: 8, right: 8),
                                child: _buildOptionButton(
                                  context: context,
                                  state: state,
                                  userType: 'student',
                                  title: "Explore Jobs",
                                  backgroundColor: const Color(0xff004673),
                                  imagePath:
                                      "lib/assets/images/others/Ellipse 1498.png",
                                  onPressed: () {
                                    context.read<OptionBloc>().add(
                                          const StudentOptionSelected(),
                                        );
                                  },
                                ),
                              ),
                            ),

                            // Employer Option Button
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 40, left: 8, right: 8),
                                child: _buildOptionButton(
                                  context: context,
                                  state: state,
                                  userType: 'employer',
                                  title: "Hire Students",
                                  backgroundColor: const Color(0xffEB8125),
                                  imagePath:
                                      "lib/assets/images/others/Ellipse 1497.png",
                                  onPressed: () {
                                    context.read<OptionBloc>().add(
                                          const EmployerOptionSelected(),
                                        );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build option buttons with loading states
  Widget _buildOptionButton({
    required BuildContext context,
    required OptionState state,
    required String userType,
    required String title,
    required Color backgroundColor,
    required String imagePath,
    required VoidCallback onPressed,
  }) {
    // Check if this button is currently being selectedñ
    final isSelecting = state is OptionSelecting && state.userType == userType;

    return ElevatedButton(
      onPressed: isSelecting ? null : onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width / 2, 172),
        backgroundColor: backgroundColor,
        disabledBackgroundColor: backgroundColor.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
      ),
      child: isSelecting
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
                Text(
                  "Loading...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(imagePath),
                  radius: 30,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }

  // Navigation method
  void _navigateToLogin(BuildContext context, String userType) {
    print("🚀 Navigating to login with user type: $userType");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Registerpage(),
      ),
    );
  }
}
