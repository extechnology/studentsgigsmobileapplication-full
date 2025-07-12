part of 'onboardprofile4_cubit.dart';

@immutable
sealed class Onboardprofile4State {}

final class Onboardprofile4Initial extends Onboardprofile4State {}

class Onboardprofile4ImagePicked extends Onboardprofile4State {
  final File image;
  Onboardprofile4ImagePicked(this.image);
}
