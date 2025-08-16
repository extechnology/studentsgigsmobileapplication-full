import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PlanService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  static String _baseUrl = '${ApiConstants.baseUrl}api/employee/';

  Future<bool> canUserSaveJobs() async {
    try {
      final plans = await fetchUserPlans();
      final currentPlan =
          plans['current_plan']?.toString().toLowerCase() ?? 'free';

      // Assuming only 'free' plan cannot save jobs
      return currentPlan != 'free';
    } catch (e) {
      return false; // Default to restricted if there's an error
    }
  }

  Future<Map<String, dynamic>> fetchUserPlans() async {
    const String endpoint = 'user-plans/';
    final String apiUrl = '$_baseUrl$endpoint';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _storage.read(key: 'access_token')}',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plan data: ${e.toString()}');
    }
  }
}

class PremiumPlan extends StatelessWidget {
  final Map<String, dynamic> planData;
  final bool isCurrentPlan;
  final Map<String, dynamic>? userPlanData;
  final VoidCallback? onUpgradePressed;

  const PremiumPlan({
    super.key,
    required this.planData,
    this.isCurrentPlan = false,
    this.userPlanData,
    this.onUpgradePressed,
  });

  bool isStandardWithOffer() {
    if (userPlanData == null) return false;

    final currentPlan =
        userPlanData!['current_plan']?.toString().toLowerCase() ?? 'free';
    final bool hasOffer = userPlanData!['offer'] ?? false;

    return currentPlan == 'standard' && hasOffer;
  }

  @override
  Widget build(BuildContext context) {
    // Extract plan details with fallbacks
    final String planName =
        planData['name']?.toString().toUpperCase() ?? 'PLAN';
    final int planPrice =
        int.tryParse(planData['price']?.toString() ?? '0') ?? 0;
    final List<dynamic> features = planData['features'] ?? [];
    final String planColor =
        planData['color'] ?? '#004673'; // Default blue color
    final bool isRecommended = planData['recommended'] ?? false;
    final isFreePlan = planData['id']?.toString().toLowerCase() == 'free';
    final canSelectFree = userPlanData?['has_used_free_plan'] != true ||
        userPlanData?['is_expired'] == true;

    // Get screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive dimensions
    final cardWidth = screenWidth > 600 ? 320.0 : 280.0;
    final cardHeight = screenHeight > 800 ? 600.0 : 660.0;
    final titleFontSize = screenWidth > 600 ? 28.0 : 26.0;
    final priceFontSize = screenWidth > 600 ? 22.0 : 20.0;
    final featureFontSize = screenWidth > 600 ? 14.0 : 12.0;

    // Get color from backend or use default
    Color headerColor = _getColorFromHex(planColor);
    Color textColor = _getTextColor(headerColor);

    // Default button color for free plan and current plan
    Color buttonColor = (isFreePlan || isCurrentPlan)
        ? Colors.grey // Grey color for disabled buttons
        : headerColor; // Use plan color for other buttons

    final priceInfo = _calculateDisplayPrice(
        planData['price']?.toString() ?? '0', planData['id']?.toString() ?? '');

    return Padding(
      padding: EdgeInsets.only(
        right: 17,
        bottom: screenHeight > 800 ? 20 : 10,
      ),
      child: Container(
        width: cardWidth,
        height: screenHeight > 800 ? 680.0 : 740.0, // Increased height
        padding: EdgeInsets.only(top: 25),
        decoration: BoxDecoration(
          color: headerColor,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(19),
              bottomRight: Radius.circular(19),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? 32 : 28,
            vertical: screenWidth > 600 ? 24 : 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Add this
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan name
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  planName,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: headerColor,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Plan price
              _buildPriceSection(priceInfo, headerColor, planPrice),
              SizedBox(height: 10),

              // Features list with flexible space
              Flexible(
                // Changed from Expanded to Flexible
                child: SingleChildScrollView(
                  // Ensure scrollable content
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: features
                        .map((feature) => _buildFeatureRow(
                            feature['name']?.toString() ?? '',
                            feature['value']?.toString() ?? '',
                            headerColor,
                            featureFontSize))
                        .toList(),
                  ),
                ),
              ),

              // Spacer to push button to bottom
              //Spacer(),

              // Upgrade button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isCurrentPlan || isFreePlan)
                        ? Colors.grey
                        : buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      (isCurrentPlan || isFreePlan) ? null : onUpgradePressed,
                  child: Text(
                    isCurrentPlan
                        ? 'Current Plan'
                        : isFreePlan
                            ? 'Free Plan'
                            : isStandardWithOffer() &&
                                    planData['id']?.toString().toLowerCase() ==
                                        'premium'
                                ? 'Upgrade with Discount'
                                : 'Select Plan',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: screenWidth > 600 ? 18 : 16,
                      color: (isCurrentPlan || isFreePlan)
                          ? Colors.white.withOpacity(0.7)
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String featureName, String featureValue,
      Color accentColor, double fontSize) {
    bool isAvailable = featureValue.toLowerCase() != 'no' &&
        featureValue.toLowerCase() != 'false' &&
        featureValue.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.cancel,
            color: isAvailable ? Colors.green : Colors.red,
            size: fontSize * 1.2,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              featureName,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: Color(0xff004673),
              ),
            ),
          ),
          if (isAvailable && featureValue.isNotEmpty)
            Text(
              featureValue,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: fontSize - 2,
                fontWeight: FontWeight.w500,
                color: accentColor,
              ),
            ),
        ],
      ),
    );
  }

  Color _getTextColor(Color backgroundColor) {
    // Calculate luminance to determine text color
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  // New method to convert hex color from backend to Flutter Color
  // Updated method to handle both hex colors and color names
  Color _getColorFromHex(String colorInput) {
    try {
      // First, check if it's a color name and convert to hex
      String hexColor = _colorNameToHex(colorInput.toLowerCase().trim());

      // Remove # if present
      String cleanHex = hexColor.replaceAll('#', '');

      // Add FF for full opacity if not present
      if (cleanHex.length == 6) {
        cleanHex = 'FF$cleanHex';
      }

      return Color(int.parse(cleanHex, radix: 16));
    } catch (e) {
      // Return default blue color if parsing fails
      return Color(0xff004673);
    }
  }

// Helper method to convert common color names to hex values
  String _colorNameToHex(String colorName) {
    final Map<String, String> colorNameMap = {
      'red': 'FF0000',
      'blue': '3b82f6',
      'green': '008000',
      'yellow': 'FFFF00',
      'orange': 'FFA500',
      'purple': '9537eb',
      'pink': 'de2e7e',
      'brown': 'A52A2A',
      'black': '000000',
      'white': 'FFFFFF',
      'gray': '808080',
      'grey': '808080',
      'cyan': '00FFFF',
      'magenta': 'FF00FF',
      'lime': '00FF00',
      'maroon': '800000',
      'navy': '000080',
      'olive': '808000',
      'teal': '008080',
      'silver': 'C0C0C0',
      'gold': 'FFD700',
      'indigo': '4B0082',
      'violet': 'EE82EE',
      'turquoise': '40E0D0',
      'coral': 'FF7F50',
      'salmon': 'FA8072',
      'khaki': 'F0E68C',
      'plum': 'DDA0DD',
      'orchid': 'DA70D6',
      'tan': 'D2B48C',
      'azure': 'F0FFFF',
      'beige': 'F5F5DC',
      'crimson': 'DC143C',
      'darkblue': '00008B',
      'darkgreen': '006400',
      'darkred': '8B0000',
      'lightblue': 'ADD8E6',
      'lightgreen': '90EE90',
      'lightgray': 'D3D3D3',
      'lightgrey': 'D3D3D3',
    };

    // If it's a color name, return the corresponding hex
    if (colorNameMap.containsKey(colorName)) {
      return colorNameMap[colorName]!;
    }

    // If it's already a hex color (with or without #), return as is
    if (colorName.startsWith('#')) {
      return colorName.substring(1);
    } else if (RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(colorName) ||
        RegExp(r'^[0-9A-Fa-f]{8}$').hasMatch(colorName)) {
      return colorName;
    }

    // If none of the above, it might be an unknown color name or invalid hex
    // Return the input as-is and let the main method handle the error
    return colorName;
  }

  Map<String, dynamic> _calculateDisplayPrice(
      String originalPrice, String planId) {
    if (userPlanData == null) {
      return {
        'displayPrice': originalPrice,
        'hasDiscount': false,
        'savings': '0',
      };
    }

    final currentPlan =
        userPlanData!['current_plan']?.toString().toLowerCase() ?? 'free';
    final bool hasOffer = userPlanData!['is_offer'] ?? false;
    final double premiumPrice = double.tryParse(originalPrice) ?? 0;

    // Get current plan price from the plan object
    double currentPlanPrice = 0;
    if (userPlanData!['plan'] != null &&
        userPlanData!['plan']['price'] != null) {
      currentPlanPrice =
          double.tryParse(userPlanData!['plan']['price'].toString()) ?? 0;
    }

    if (currentPlan == 'standard' &&
        hasOffer &&
        planId.toLowerCase() == 'premium') {
      final discount = currentPlanPrice / 2;
      final discountedPrice = premiumPrice - discount;

      // Return exact decimal values without rounding
      if (discountedPrice > 0 && discountedPrice < premiumPrice) {
        return {
          'displayPrice': discountedPrice.toString(), // Keep full decimal
          'originalPrice': premiumPrice.toStringAsFixed(0),
          'hasDiscount': true,
          'savings': discount.toString(), // Keep full decimal
          'exactPrice': discountedPrice, // Add exact numeric value
        };
      }
    }

    // Default case - no discount
    return {
      'displayPrice': premiumPrice.toStringAsFixed(0),
      'hasDiscount': false,
      'savings': '0',
    };
  }

  Widget _buildPriceSection(
      Map<String, dynamic> priceInfo, Color headerColor, int planPrice) {
    // Format the display price (show .5 decimal when present)
    String displayPrice = priceInfo['hasDiscount']
        ? priceInfo['exactPrice']?.toStringAsFixed(1) ??
            priceInfo['displayPrice']
        : priceInfo['displayPrice'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price display
        if (priceInfo['hasDiscount'])
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rs. ${priceInfo['originalPrice']}',
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Rs. $displayPrice', // Show exact price with decimal
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: headerColor,
                ),
              ),
            ],
          )
        else
          Text(
            planPrice == 0 ? 'FREE' : 'Rs. ${priceInfo['displayPrice']}',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: headerColor,
            ),
          ),
      ],
    );
  }

  Map<String, dynamic> _getPlanRestrictions(String planId) {
    if (userPlanData == null) {
      return {
        'canUpgrade': true,
        'message': null,
        'isWarning': false,
      };
    }

    final currentPlan =
        userPlanData!['current_plan']?.toString().toLowerCase() ?? 'free';
    final bool hasActivePlan = userPlanData!['has_active_plan'] ?? false;
    final bool isPlanExpired = userPlanData!['is_expired'] ?? false;
    final bool hasUsedFreePlan = userPlanData!['has_used_free_plan'] ?? false;

    // Always allow free plan selection
    if (planId == 'free') {
      if (currentPlan == 'free' && hasActivePlan && !isPlanExpired) {
        return {
          'canUpgrade': false,
          'message': 'Current free plan',
          'isWarning': false,
        };
      }
      return {
        'canUpgrade': true,
        'message': 'Select free plan',
        'isWarning': false,
      };
    }

    // Current plan
    if (isCurrentPlan && hasActivePlan && !isPlanExpired) {
      return {
        'canUpgrade': false,
        'message': 'Current active plan',
        'isWarning': false,
      };
    }

    // Paid plans when user has active plan (not expired)
    if (planId != 'free' && hasActivePlan && !isPlanExpired) {
      return {
        'canUpgrade': true,
        'message': 'Upgrade available',
        'isWarning': false,
      };
    }

    // Paid plans when plan is expired
    if (planId != 'free' && isPlanExpired) {
      return {
        'canUpgrade': true,
        'message': 'Renew your subscription',
        'isWarning': false,
      };
    }

    return {
      'canUpgrade': true,
      'message': null,
      'isWarning': false,
    };
  }

  String _getButtonText(Map<String, dynamic> restrictions, bool isCurrentPlan) {
    if (isCurrentPlan) {
      return 'Current Plan';
    }

    if (restrictions['message'] == 'Current free plan') {
      return 'Current Free Plan';
    }

    if (restrictions['message'] == 'Select free plan') {
      return 'Get Free Plan';
    }
    if (!restrictions['canUpgrade']) {
      if (restrictions['message'] == 'Free plan can only be used once') {
        return 'Already Used';
      } else if (restrictions['message'] == 'Already on free plan') {
        return 'Current Plan';
      } else if (restrictions['message'] == 'Current active plan') {
        return 'Active';
      }
      return 'Not Available';
    }

    if (restrictions['message'] == 'Renew your subscription') {
      return 'Renew Now';
    } else if (restrictions['message'] == 'Switch to free plan') {
      return 'Switch';
    } else if (restrictions['message'] == 'Upgrade available') {
      return 'Upgrade';
    }

    return 'Select Plan';
  }
}
