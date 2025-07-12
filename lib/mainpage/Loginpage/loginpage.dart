import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/login_cubit.dart';

class GoogleSignInPage extends StatelessWidget {
  const GoogleSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Google Sign-In")),
        body: Center(
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginError &&
                  !state.message.contains('canceled')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is LoginIoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Signed in as ${state.email}')),
                );
              }
            },
            builder: (context, state) {
              if (state is LoginIoading) {
                return const CircularProgressIndicator();
              } else if (state is LoginIoaded) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Welcome, ${state.name}"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.read<LoginCubit>().signOut(),
                      child: const Text("Sign Out"),
                    ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not signed in"),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text("Sign in with Google"),
                    onPressed: () {
                      context.read<LoginCubit>().signIn(context, "student"); // or "employer", "admin"
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
