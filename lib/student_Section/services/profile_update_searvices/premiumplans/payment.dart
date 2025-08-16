import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplans/premiumplan.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

class PaymentService {
  late Razorpay _razorpay;
  BuildContext? _currentContext;
  String? _currentPlan;

  PaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> startRazorpayPayment({
    required BuildContext context,
    required String orderId,
    required int amount,
    required String currency,
    required String plan,
  }) async {
    // Store context and order details for callback handlers
    _currentContext = context;
    _currentPlan = plan;

    // Payment options
    var options = {
      'key': 'rzp_live_ic7tdu8aeCEoSo', // Replace with your Razorpay Key ID
      'amount': amount, // in paise
      'currency': currency,
      'name': 'Student Gigs',
      'description': 'Payment for $plan Premium Plan',
      'order_id': orderId, // This is important - include the order_id
      'prefill': {
        'contact': '9876543210',
        'email': 'test@razorpay.com',
      },
      'external': {
        'wallets': ['paytm']
      },
      'theme': {'color': '#3399cc'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment initialization failed: $e')),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_currentContext != null) {
      // Show immediate success feedback
      ScaffoldMessenger.of(_currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Payment successful! Verifying...'),
          backgroundColor: Colors.green,
        ),
      );

      // Call verifyPayment with context and complete response data
      verifyPayment(
        _currentContext!, // BuildContext as first parameter
        response.data, // Map<dynamic, dynamic> as second parameter
      );
    } else {}
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (_currentContext != null) {
      ScaffoldMessenger.of(_currentContext!).showSnackBar(
        SnackBar(
          content:
              Text('Payment failed: ${response.message ?? 'Unknown error'}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (_currentContext != null) {
      ScaffoldMessenger.of(_currentContext!).showSnackBar(
        SnackBar(
          content: Text('External Wallet Selected: ${response.walletName}'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  // Dispose method to clean up resources
  void dispose() {
    _razorpay.clear();
    _currentContext = null;
    _currentPlan = null;
  }
}
