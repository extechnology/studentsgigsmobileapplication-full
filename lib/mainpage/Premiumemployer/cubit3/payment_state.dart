part of 'razerpay_cubit.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentStarted extends PaymentState {}


class PaymentSuccessVerifying extends PaymentState {}

class PaymentVerified extends PaymentState {}

class PaymentVerificationFailed extends PaymentState {
  final String message;
  PaymentVerificationFailed(this.message);
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}

class PaymentExternalWalletSelected extends PaymentState {
  final String walletName;
  PaymentExternalWalletSelected({required this.walletName});
}
class PaymentSuccess extends PaymentState {}

