import 'package:anjalim/intro_screens/splash/auth_repository.dart';
import 'package:anjalim/intro_screens/splash/bloc/splash_bloc.dart';
import 'package:anjalim/intro_screens/splash/bloc/splash_event.dart';
import 'package:anjalim/intro_screens/splash/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(
        authRepository: AuthRepository(),
      )..add(const SplashStarted()),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      body: SafeArea(
        child: BlocListener<SplashBloc, SplashState>(
          // Listen to state changes for navigation
          listener: (context, state) {
            if (state is SplashAuthenticated) {
              _navigateToUserDashboard(context, state.userType);
            } else if (state is SplashUnauthenticated) {
              _navigateToWelcomeScreen(context);
            } else if (state is SplashError) {
              // Handle error state if needed
            }
          },
          child: BlocBuilder<SplashBloc, SplashState>(
            // Build UI based on current state
            builder: (context, state) {
              return Center(
                child: _buildSplashContent(state),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSplashContent(SplashState state) {
    return AnimatedSplashLogo(
      isAnimating: state is SplashAnimating || state is SplashCheckingAuth,
    );
  }

  void _navigateToUserDashboard(BuildContext context, String userType) {
    switch (userType.toLowerCase()) {
      case 'student':
        Navigator.pushReplacementNamed(context, 'StudentHomeScreens');
        break;
      case 'employer':
        Navigator.pushReplacementNamed(context, 'Dashborad');
        break;
      // case 'admin':
      //   Navigator.pushReplacementNamed(context, 'AdminDashboard');
      //   break;
      default:
        _navigateToWelcomeScreen(context);
        break;
    }
  }

  void _navigateToWelcomeScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, 'WelcomeScreen');
  }
}

class AnimatedSplashLogo extends StatefulWidget {
  final bool isAnimating;

  const AnimatedSplashLogo({
    super.key,
    required this.isAnimating,
  });

  @override
  _AnimatedSplashLogoState createState() => _AnimatedSplashLogoState();
}

class _AnimatedSplashLogoState extends State<AnimatedSplashLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    if (widget.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedSplashLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.forward();
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                  maxHeight: 200,
                ),
                child: Image.asset(
                  "assets/images/logos/image 1.png",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
