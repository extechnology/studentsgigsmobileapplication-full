import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'spash_state.dart';

class SpashCubit extends Cubit<SpashState> {
  SpashCubit() : super(SpashInitial());
}
