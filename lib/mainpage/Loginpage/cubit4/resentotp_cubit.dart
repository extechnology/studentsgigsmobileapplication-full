import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'resentotp_state.dart';

class ResentotpCubit extends Cubit<ResentotpState> {
  ResentotpCubit() : super(ResentotpInitial());
}
