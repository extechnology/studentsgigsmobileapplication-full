import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/spash_cubit.dart';

class Spashscreen extends StatelessWidget {
  const Spashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpashCubit()..getToken(context),
      child: BlocBuilder<SpashCubit, SpashState>(
        builder: (context, state) {
          return const Scaffold(
            body: Column(
              children: [
                const Text("Texting "),
              ],
            ),
          );
        },
      ),
    );
  }
}
