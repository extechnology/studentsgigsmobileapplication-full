import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loginpag_state.dart';

class LoginpagCubit extends Cubit<LoginpagState> {
  LoginpagCubit() : super(LoginpagInitial());
}
