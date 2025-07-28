import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../dashborad/dashborad.dart';
import '../../datapage/datapage.dart';
import '../../registerpage/loginpageog.dart';

part 'spash_state.dart';

class SpashCubit extends Cubit<SpashState> {
  SpashCubit() : super(SpashInitial());

  Future<void> getToken(BuildContext context) async {
    final token = await ApiConstants.getTokenOnly();    // Await the future properly
    final tokens = await ApiConstants.getTokenOnly2();  // Await the second token as well

    if (token != null && token.isNotEmpty || tokens != null && tokens.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Dashborad()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Registerpage()),
      );
    }
  }

}
