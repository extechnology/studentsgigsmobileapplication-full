import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'postregister_state.dart';

class PostregisterCubit extends Cubit<PostregisterState> {
  PostregisterCubit() : super(PostregisterInitial());
}
