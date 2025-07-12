import 'package:anjalim/mainpage/Premiumemployer/cubit/prrmiumemployer_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../razerpaydemo/cubit/razerpay_cubit.dart';
import 'cubit2/premium_cubit.dart';
import 'cubit3/razerpay_cubit.dart';
import 'model/model.dart';

class Premiumemployerpage extends StatelessWidget {
  Premiumemployerpage({super.key});
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => PrrmiumemployerCubit()..fetchPlans(),
    ),
    BlocProvider(
      create: (context) => PremiumCubit()..fetchPremiumPlan(),
    ),
    BlocProvider(
      create: (context) => PaymentCubit(), // ✅ Added for Razorpay
    ),
  ],
        child: BlocConsumer<PaymentCubit, PaymentState>(
            listener: (context, paymentState) {
              if (paymentState is PaymentError || paymentState is PaymentVerificationFailed) {
                final message = paymentState is PaymentError
                    ? paymentState.message
                    : (paymentState as PaymentVerificationFailed).message;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: Colors.red),
                );
              }

              if (paymentState is PaymentExternalWalletSelected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected wallet: ${paymentState.walletName}")),
                );
              }

              if (paymentState is PaymentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment Successful!")));
                // ✅ FETCH THE LATEST PLAN
                context.read<PremiumCubit>().fetchPremiumPlan();
              }
            },
            builder: (context, paymentState) {
              return
                BlocBuilder<PrrmiumemployerCubit, PrrmiumemployerState>(
                  builder: (context, state) {
                    final cubit = context.read<PrrmiumemployerCubit>();
                    return SafeArea(
                      child: Scaffold(
                        backgroundColor: const Color(0xffF9F2ED),
                        body: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery
                                  .of(context)
                                  .viewInsets
                                  .bottom + height * 0.1,
                              right: width * 0.05,
                              left: width * 0.05,
                              top: MediaQuery
                                  .of(context)
                                  .viewInsets
                                  .top + height * 0.03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height * 0.002),
                                Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xffE3E3E3)),
                                    color: const Color(0xffF9F2ED),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                        Icons.arrow_back, color: Colors.black,
                                        size: 24),
                                  ),
                                ),
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xffEB8125),
                                        Color(0xffc55a5f),
                                        Color(0xff004673),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.srcIn,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 280,
                                      child: Text(
                                        "Upgrade Your Job Posting Experience",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    'Engage the most talented candidates with our premium\nfeatures',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      height: 1.7,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  child:
                                  BlocBuilder<PremiumCubit, PremiumState>(
                                    builder: (context, state) {
                                      if (state is PremiumLoading) {
                                        return CircularProgressIndicator();
                                      } else if (state is PremiumLoaded) {
                                        return Text(
                                            "Plan Name: ${state.premium.plan.name}");
                                      } else if (state is PremiumError) {
                                        return Text("Error: ${state.message}");
                                      } else {
                                        return SizedBox(); // or Text("No data loaded yet")
                                      }
                                    },
                                  )
                                  ,
                                ),

                                if (state is PrrmiumemployerIoading) ...[
                                  const Center(
                                      child: CircularProgressIndicator()),
                                ] else
                                  if (state is PrrmiumemployerIoaded) ...[
                                    SizedBox(
                                      height: 700,
                                      width: double.infinity,
                                      child: PageView.builder(
                                        controller: controller,
                                        itemCount: state.plans.length,
                                        itemBuilder: (context, index) {
                                          final plan = state.plans[index];
                                          return _buildPlanCard(plan, context);
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: SmoothPageIndicator(
                                        controller: controller,
                                        count: state.plans.length,
                                        effect: ExpandingDotsEffect(
                                          activeDotColor: const Color(
                                              0xffEB8125),
                                          dotColor: Colors.grey.shade400,
                                          dotHeight: 8,
                                          dotWidth: 8,
                                          expansionFactor: 3,
                                        ),
                                      ),
                                    ),
                                  ] else
                                    if (state is PrrmiumemployerError) ...[
                                      Center(child: Text(state.message)),
                                    ],

                                InkWell(

                                   onTap: () {
                      context.read<PaymentCubit>().startPaymentProcess(
                        context: context,
                        amount: 1,
                        currency: 'INR',
                        plan: 'standard',
                      );
                    },
                                    child: Text("data"))

                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );

            } ),

              );
  }


  Widget _buildPlanCard( PremiumPageModel plan,  BuildContext context  ) {
    final premiumState = context.watch<PremiumCubit>().state;

    bool isCurrentPlan = false;

    String ? currentPlanId = '';
    if (premiumState is PremiumLoaded) {
      currentPlanId = premiumState.premium.plan!.id;
      isCurrentPlan = currentPlanId == plan.id;
    }

// Check if upgrade is allowed
    bool isSelectable = false;

    if (currentPlanId == "free") {
      isSelectable = (plan.id == "standard" || plan.id == "premium");
    } else if (currentPlanId == "standard") {
      isSelectable = (plan.id == "premium");
    } else if (currentPlanId == "premium") {
      isSelectable = false; // cannot upgrade beyond premium
    }
    return Card(
      margin:  EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Color(0xffFFFFFF),
      child: Padding(
        padding:  EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isCurrentPlan
                ? Container(
              decoration: BoxDecoration(
                color: getPlanColor(plan.color),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.04,
              child: const Center(
                child: Text(
                  "CURRENT",
                  style: TextStyle(color: Color(0xffFFFFFF)),
                ),
              ),
            )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: double.infinity,
              decoration: BoxDecoration(
                color: getPlanColor(plan.color),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),

                ),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
              child: Text(
                  plan.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
            ),
            const SizedBox(height: 8),
             Padding(
               padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
               child: Text(
                 "${plan.price == '0' ? 'Free' : 'Rs.${plan.price}'}",
                  style: const TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold ),
                ),
             ),
            const Divider(color: Colors.white60),
            Expanded(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: plan.features.length,
                itemBuilder: (context, i) {
                  final feature = plan.features[i];
                  return ListTile(
                    dense: true,
                    title: Text(feature.name,
                        style:  TextStyle(fontSize: 14, color: Color(0xff000000))),
                    trailing: Text(feature.value,
                        style:  TextStyle(fontSize: 14, color:  getFeatureColor(feature.value,plan),)),
                  );
                },
              ),
            ),
            // if (plan.recommended)
            //   const Center(
            //     child: Padding(
            //       padding: EdgeInsets.only(top: 8),
            //       child: Text(
            //         'Recommended Plan!',
            //         style: TextStyle(fontSize: 14, color: Colors.yellow),
            //       ),
            //     ),
            //   ),


            Center(
              child: GestureDetector(
                onTap: isSelectable
                    ? () {
                  context.read<PaymentCubit>().startPaymentProcess(
                    context: context,
                    amount: int.parse(plan.price), // Or a mapped amount
                    currency: 'INR',
                    plan: plan.id,
                  );
                }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isCurrentPlan
                        ? getPlanColor(plan.color)
                        : isSelectable
                        ? getPlanColor(plan.color)
                        : getPlanColor(plan.color).withOpacity(0.5), // 0.0 = transparent, 1.0 = full color

                    borderRadius: BorderRadius.circular(15),
                    boxShadow: isCurrentPlan
                        ? [BoxShadow(color: getPlanColor(plan.color).withOpacity(0.4), blurRadius: 8)]
                        : [],
                  ),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.045,
                  child: Center(
                    child: Text(
                      isCurrentPlan
                          ? "Current Plan"
                          : isSelectable
                          ? "Upgrade Now"
                          : "Upgrade Now",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,)
          ],
        ),
      ),
    );
  }

  Color getPlanColor(String color) {
    switch (color.toLowerCase()) {
      case 'blue':
        return Colors.blue.shade400;
      case 'purple':
        return Colors.purple.shade400;
      case 'pink':
        return Colors.pink.shade400;
      default:
        return Colors.grey.shade300;
    }
  }
  Color getFeatureColor(String value,plan ) {
    if (value.toLowerCase() == 'yes') {
      return Colors.green;
    } else if (value.toLowerCase() == 'no'){
      return Colors.black;
    }else {
      return getPlanColor(plan.color);
    }
  }
}
