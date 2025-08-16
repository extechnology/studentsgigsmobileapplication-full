import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplan1.dart';
import 'package:flutter/material.dart';

class JobCard extends StatelessWidget {
  final String id;
  final String jobType;
  final String position;
  final String timeAgo;
  final String salary;
  final String salaryType;
  final bool applied;
  final String logo;
  final String company;
  final String location;
  final String employerId;
  final bool saved;
  final bool isLoading;
  final Function() onSave;

  const JobCard({
    Key? key,
    required this.id,
    required this.jobType,
    required this.position,
    required this.timeAgo,
    required this.salary,
    required this.salaryType,
    required this.applied,
    required this.logo,
    required this.company,
    required this.location,
    required this.employerId,
    required this.saved,
    required this.isLoading,
    required this.onSave,
  }) : super(key: key);

  // Helper method to check if URL is valid network URL
  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Helper method to check if it's an asset path
  bool _isAssetPath(String path) {
    return path.isNotEmpty && path.startsWith('assets/');
  }

  // Helper method to get the first letter of company name for fallback
  String _getCompanyInitial() {
    return company.isNotEmpty ? company[0].toUpperCase() : '?';
  }

  // Helper method to get status color
  Color _getStatusColor() {
    return applied ? Color(0xff4CAF50) : Color(0xff757575);
  }

  // Helper method to format salary display
  String _getFormattedSalary() {
    return "₹$salary ${salaryType.toLowerCase()}";
  }

  // Widget to build the appropriate image widget
  Widget _buildCompanyLogo() {
    if (_isValidUrl(logo)) {
      // Network image
      return ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          logo,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackLogo();
          },
        ),
      );
    } else if (_isAssetPath(logo)) {
      // Asset image - but we'll use fallback since assets might not exist
      return _buildFallbackLogo();
    } else {
      // Fallback for empty or invalid logo
      return _buildFallbackLogo();
    }
  }

  // Widget to build fallback logo
  Widget _buildFallbackLogo() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          _getCompanyInitial(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02, vertical: screenWidth * 0.01),
      padding: EdgeInsets.all(screenWidth * 0.045),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Position, Time, Save Button
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff1A1A1A),
                        fontSize: screenWidth * 0.048,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          color: Color(0xff757575),
                          size: screenWidth * 0.035,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xff757575),
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              // Save Button with Green Color
              GestureDetector(
                onTap: () async {
                  final canSave = await PlanService().canUserSaveJobs();
                  if (canSave) {
                    onSave();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Upgrade your plan to save jobs'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: saved ? Color(0xffE8F5E8) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: saved ? Color(0xff4CAF50) : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: screenWidth * 0.04,
                          height: screenWidth * 0.04,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xff4CAF50),
                          ),
                        )
                      : Icon(
                          saved
                              ? Icons.bookmark
                              : Icons.bookmark_border_outlined,
                          color: saved ? Color(0xff4CAF50) : Color(0xff757575),
                          size: screenWidth * 0.045,
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          // Company Section with Location
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: _buildCompanyLogo(),
              ),
              SizedBox(width: screenWidth * 0.035),
              //loc and company name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.038,
                        color: Color(0xff1A1A1A),
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: screenWidth * 0.012),
                    // Location moved here with improved styling
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color(0xffFF5722),
                          size: screenWidth * 0.035,
                        ),
                        SizedBox(width: screenWidth * 0.008),
                        Flexible(
                          child: Text(
                            location,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Color(0xff757575),
                              fontSize: screenWidth * 0.032,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: screenWidth * 0.04),

          // Divider
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),

          SizedBox(height: screenWidth * 0.04),

          // Bottom Section: Job Details
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Salary",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff757575),
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Row(
                      children: [
                        Icon(
                          Icons.currency_rupee,
                          color: Color(0xff4CAF50),
                          size: screenWidth * 0.04,
                        ),
                        SizedBox(width: screenWidth * 0.005),
                        Flexible(
                          child: Text(
                            "$salary",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Color(0xff1A1A1A),
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      salaryType,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff757575),
                        fontSize: screenWidth * 0.028,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              //job type
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Job Type",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff757575),
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenWidth * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xffE8F5E8),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Color(0xff4CAF50).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        jobType,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xff4CAF50),
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              //job status
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff757575),
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.025,
                        vertical: screenWidth * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        applied ? "Applied ✓" : "Not Applied",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: screenWidth * 0.028,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
