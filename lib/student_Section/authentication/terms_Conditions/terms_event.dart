abstract class TermsEvent {}

class ToggleTermsAcceptance extends TermsEvent {
  final bool isAccepted;

  ToggleTermsAcceptance(this.isAccepted);
}
