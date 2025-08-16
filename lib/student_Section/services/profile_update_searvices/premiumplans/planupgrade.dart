import 'dart:convert';
import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplans/payment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlanUpgradeService {
  final PaymentService _paymentService = PaymentService();

  // You'll need to define these models based on your data structure
  Map<String, dynamic>? currentPlanData;
  String? currentPlan;
  bool isOffer = false; // Set this based on your offer logic

  Future<void> handlePlanUpgrade({
    required BuildContext context,
    required String plan,
    required String planPrice,
    Map<String, dynamic>? userInfo,
    Function(bool)? setProgress,
    Function(String)? showToast,
  }) async {
    try {
      // Set progress to true (show loading)
      setProgress?.call(true);

      // Validation check
      if (currentPlanData == null || currentPlan == null) {
        showToast?.call("Something went wrong");
        return;
      }

      // Convert plan_price to number
      final double numericPrice = double.tryParse(planPrice) ?? 0.0;

      // Condition to determine the price
      double finalPrice;
      if (plan == 'premium' &&
          currentPlan?.toLowerCase() == 'standard' &&
          isOffer) {
        final double currentPlanPrice =
            double.tryParse(currentPlanData?['price']?.toString() ?? '0') ??
                0.0;
        finalPrice = numericPrice - (0.5 * currentPlanPrice);
      } else {
        finalPrice = numericPrice;
      }

      // Create the request body
      final Map<String, dynamic> requestBody = {
        "amount": finalPrice.toString(),
        "currency": "INR",
        "plan": plan,
      };

      // Make the API call to create order
      await _createOrder(
        context: context,
        requestBody: requestBody,
        finalPrice: finalPrice,
        plan: plan,
        userInfo: userInfo,
        showToast: showToast,
      );
    } catch (err) {
      showToast?.call("Something went wrong.");
    } finally {
      // Set progress to false after a delay
      Future.delayed(const Duration(milliseconds: 500), () {
        setProgress?.call(false);
      });
    }
  }

  Future<void> _createOrder({
    required BuildContext context,
    required Map<String, dynamic> requestBody,
    required double finalPrice,
    required String plan,
    Map<String, dynamic>? userInfo,
    Function(String)? showToast,
  }) async {
    const String endpoint = "api/employee/create-order-employee/";
    final String url = "${ApiConstants.baseUrl}$endpoint";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: await ApiConstants.headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse the response
        final responseData = json.decode(response.body);

        // Get the order id
        final String orderId = responseData['id'];

        // Initialize Razorpay payment
        await _initializeRazorpay(
          context: context,
          orderId: orderId,
          finalPrice: finalPrice,
          plan: plan,
          userInfo: userInfo,
          showToast: showToast,
        );
      } else {
        showToast?.call("Something went wrong");
      }
    } catch (e) {
      showToast?.call("Something went wrong");
      rethrow;
    }
  }

  Future<void> _initializeRazorpay({
    required BuildContext context,
    required String orderId,
    required double finalPrice,
    required String plan,
    Map<String, dynamic>? userInfo,
    Function(String)? showToast,
  }) async {
    // Convert amount to paise (multiply by 100)
    final int amountInPaise = (finalPrice * 100).round();

    try {
      // Start Razorpay payment using your existing PaymentService
      await _paymentService.startRazorpayPayment(
        context: context,
        orderId: orderId,
        amount: amountInPaise,
        currency: "INR",
        plan: plan,
      );

      // Note: Payment success/failure will be handled by your existing
      // PaymentService callbacks (_handlePaymentSuccess, _handlePaymentError)
    } catch (e) {
      showToast?.call("Payment initialization failed");
    }
  }

  // Helper method to set current plan data
  void setCurrentPlanData(
      Map<String, dynamic>? planData, String? plan, bool offer) {
    currentPlanData = planData;
    currentPlan = plan;
    isOffer = offer;
  }

  // Dispose method
  void dispose() {
    _paymentService.dispose();
  }
}
