// // lib/Student/StudentFunctions/premiumplans/payment_cubit.dart
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:http/http.dart' as http;
//
// part 'payment_state.dart';
//
// class PaymentCubit extends Cubit<PaymentState> {
//   PaymentCubit() : super(PaymentInitial()) {
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleFailure);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//   final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUxNzExNDk3LCJpYXQiOjE3NTExMDY2OTcsImp0aSI6IjgzNDYwOWZhNWVhZjRlYWU4ZmY4YWQ0ZGRiM2E3YmE1IiwidXNlcl9pZCI6MTAzfQ.GipF3tSrr-2QaIntovtZFTbqI_6rIFO80uT3V-F_PJE";
//
//
//   late Razorpay _razorpay;
//   BuildContext? _context;
//
//   void startPaymentProcess({
//     required BuildContext context,
//     required int amount,
//     required String currency,
//     required String plan,
//   }) async {
//     _context = context;
//     emit(PaymentLoading());
//
//     const String url = "https://aee7-2403-a080-c04-72f4-39d8-681-d0de-27a2.ngrok-free.app/api/employer/create-order-employer/";
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//           body: {
//             'amount': amount.toString(),
//             'currency': currency,
//             'plan': plan,
//           }
//       );
//
//       if (response.statusCode == 200) {
//         print(" hey error ${response.statusCode}");
//         final data = json.decode(response.body);
//         String orderId = data['id'];
//         int orderAmount = data['amount'];
//
//         // String plan = data[]
//
//         _razorpay.open({
//           'key': 'rzp_test_JJEW8E6TC9K8Lj',
//           'amount': orderAmount,
//           'currency': currency,
//           'name': 'Student Gigs',
//           'description': 'Payment for $plan Premium Plan',
//           'order_id': orderId,
//           'prefill': {
//             'contact': '9876543210',
//             'email': 'test@razorpay.com',
//           },
//           'external': {
//             'wallets': ['paytm']
//           },
//           'theme': {'color': '#3399cc'}
//         });
//
//         emit(PaymentStarted());
//       } else {
//         emit(PaymentError("Order creation failed: ${response.body}"));
//       }
//     } catch (e) {
//       emit(PaymentError("Network error: $e"));
//     }
//   }
//
//   void _handleSuccess(PaymentSuccessResponse response) async {
//     final paymentData = response.data;
//     print(" hey error ${response.data}");
//
//     print("✅ Payment ID: ${paymentData!['razorpay_payment_id']}");
//     print("📦 Order ID: ${paymentData['razorpay_order_id']}");
//     print("🔐 Signature: ${paymentData['razorpay_signature']}");
//
//     emit(PaymentSuccessVerifying());
//
//     const String url = "https://aee7-2403-a080-c04-72f4-39d8-681-d0de-27a2.ngrok-free.app/api/employer/verify-payment-employer/";
//
//     try {
//       final verifyResponse = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({"response": paymentData}),
//       );
//
//       if (verifyResponse.statusCode == 200) {
//         print(" hey bro ${verifyResponse.statusCode}");
//
//         emit(PaymentVerified());
//
//         if (_context != null) {
//           showDialog(
//             context: _context!,
//             barrierDismissible: false,
//             builder: (_) => AlertDialog(
//               title: const Column(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.green),
//                   Text("Payment Successful!"),
//                 ],
//               ),
//               content: const Text("Your plan has been activated successfully."),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(_context!).pop();
//                     Navigator.pushNamed(_context!, "PremiumPlansScreen");
//                   },
//                   child: const Text("OK"),
//                 ),
//               ],
//             ),
//           );
//         }
//       } else {
//         print("hey eror ${verifyResponse.body} ");
//         emit(PaymentVerificationFailed("Verification failed: ${verifyResponse.body}")
//
//     );
//       }
//     } catch (e) {
//       print("hey eror $e ");
//
//       emit(PaymentVerificationFailed("Network error: $e"));
//     }
//   }
//
//   void _handleFailure(PaymentFailureResponse response) {
//     emit(PaymentError("Payment failed: ${response.message}"));
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     emit(PaymentExternalWalletSelected(walletName: response.walletName ?? ''));
//   }
//
//   @override
//   Future<void> close() {
//     _razorpay.clear();
//     return super.close();
//   }
// }
