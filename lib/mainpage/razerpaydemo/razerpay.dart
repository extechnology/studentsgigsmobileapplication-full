// // lib/Student/StudentFunctions/premiumplans/premium_plans_screen.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'cubit/razerpay_cubit.dart';
//
// class PremiumPlansScreen extends StatelessWidget {
//   const PremiumPlansScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => PaymentCubit(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Choose Your Plan'),
//           backgroundColor: Colors.deepPurple,
//         ),
//         body: BlocConsumer<PaymentCubit, PaymentState>(
//           listener: (context, state) {
//             // Handle errors
//             if (state is PaymentError || state is PaymentVerificationFailed) {
//               final message = state is PaymentError
//                   ? state.message
//                   : (state as PaymentVerificationFailed).message;
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//
//             // Handle external wallet selection
//             if (state is PaymentExternalWalletSelected) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Selected wallet: ${state.walletName}")),
//               );
//             }
//           },
//           builder: (context, state) {
//             // Show loading while processing
//             if (state is PaymentLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   PlanCard(
//                     title: 'standard Gold',
//                     price: '10',
//                     onTap: () {
//                       context.read<PaymentCubit>().startPaymentProcess(
//                         context: context,
//                         amount: 10, // Razorpay expects amount in paise (₹50 = 5000)
//                         currency: 'INR',
//                         plan: 'standard',
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   PlanCard(
//                     title: 'Premium Silver',
//                     price: '30',
//                     onTap: () {
//                       context.read<PaymentCubit>().startPaymentProcess(
//                         context: context,
//                         amount: 1,
//                         currency: 'INR',
//                         plan: 'premium',
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class PlanCard extends StatelessWidget {
//   final String title;
//   final String price;
//   final VoidCallback onTap;
//
//   const PlanCard({
//     super.key,
//     required this.title,
//     required this.price,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text("Enjoy $title plan with more features"),
//         trailing: ElevatedButton(
//           onPressed: onTap,
//           child: Text("Buy for $price"),
//         ),
//       ),
//     );
//   }
// }
