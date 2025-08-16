import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplans/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> planTrigger({
  required BuildContext context,
  required int amount,
  required String currency,
  required String plan,
}) async {
  final _PaymentService = PaymentService();
  const String endpoint = "api/employee/create-order-employee/";
  final String url = "${ApiConstants.baseUrl}$endpoint";

  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: await ApiConstants.headers,
      body: json.encode({
        "amount": amount.toString(),
        "currency": currency,
        "plan": plan,
      }),
    );

    // Always close the loading dialog
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      // Parse the response
      final responseData = json.decode(response.body);

      // Extract order ID and amount from response
      String orderId = responseData['id'];
      int orderAmount = responseData['amount'];

      // Initialize and start Razorpay payment
      await _PaymentService.startRazorpayPayment(
        context: context,
        orderId: orderId,
        amount: orderAmount,
        currency: currency,
        plan: plan,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order creation failed: ${response.body}')),
      );
      throw Exception(
          'Order creation failed with status ${response.statusCode}');
    }
  } catch (e) {
    // Ensure loading dialog is closed even if error occurs
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );

    throw e;
  }
}

Future<void> verifyPayment(
    BuildContext context, Map<dynamic, dynamic>? paymentData) async {
  if (paymentData == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid payment data')),
    );
    return;
  }
  const String endpoint = "api/employee/verify-payment-employee/";
  final String url = "${ApiConstants.baseUrl}$endpoint";

  // print('💳 Payment ID: $paymentId');
  // print('📋 Order ID: $orderId');
  // print('🔐 Signature: $signature');
  // print('📦 Plan: $plan');

  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text('Verifying payment...'),
        ],
      ),
    ),
  );

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: await ApiConstants.headers,
      body: json.encode({"response": paymentData}),
    );

    // Close loading dialog
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    //p//rint('📡 Verification response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      //print('✅ Payment verified successfully: ${response.body}');

      // Show success dialog instead of snackbar for better visibility
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 25),
              SizedBox(width: 10),
              Text('Payment Successful!'),
            ],
          ),
          content: Text('Your plan has been activated successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Navigate to success screen or back to plans
                Navigator.pushNamed(context,
                    "PremiumPlansScreen"); // Go back to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // Optional: Navigate to a specific success screen
      // Navigator.pushReplacementNamed(context, '/payment-success');
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text('Verification Failed'),
            ],
          ),
          content: Text('Payment verification failed. Please contact support'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    // Close loading dialog
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    // Show error dialog
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text('Network Error'),
          ],
        ),
        content: Text(
            'Failed to verify payment due to network error.\n\nError: ${e.toString()}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
