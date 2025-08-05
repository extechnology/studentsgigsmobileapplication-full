class TermsState {
  final bool isAccepted;

  const TermsState({this.isAccepted = false});

  TermsState copyWith({bool? isAccepted}) {
    return TermsState(
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }
}
