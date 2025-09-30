import 'package:anjalim/student_Section/authentication/google_Auth/googlesignup.dart';
import 'package:anjalim/student_Section/authentication/other_functionalities/forgot_password.dart';
import 'package:anjalim/student_Section/models_std/employee_Profile/employeeProfileImages.dart';
import 'package:anjalim/student_Section/services/student_Imageupload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  EmployeeProfile? _profileData;
  bool _isLoading = true;
  late ScrollController _scrollController;
  bool _showProfilePicInAppBar = false;
  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    loadProfileData();
  }

  void _scrollListener() {
    // Show profile pic in app bar when scrolled past the profile header
    if (_scrollController.hasClients) {
      bool shouldShow =
          _scrollController.offset > 120; // Adjust threshold as needed
      if (shouldShow != _showProfilePicInAppBar) {
        setState(() {
          _showProfilePicInAppBar = shouldShow;
        });
      }
    }
  }

  Future<void> loadProfileData() async {
    try {
      final data = await fetchEmployeeProfile();
      setState(() {
        _profileData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to launch URLs
  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Could not open the link",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Error opening the link",
                  style: TextStyle(fontFamily: "Poppins"),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffEB8125)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          // Custom App Bar with Cover Photo
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xffF9F2ED),
            leading: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showProfilePicInAppBar
                  ? Container(
                      key: const ValueKey('profile_pic'),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: (_profileData?.profilePic != null &&
                                _profileData!.profilePic!.isNotEmpty)
                            ? NetworkImage(_profileData!.profilePic!)
                                as ImageProvider
                            : const AssetImage(
                                "assets/images/others/Group 69.png"),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showProfilePicInAppBar && _profileData?.username != null
                  ? Text(
                      _profileData!.username,
                      key: const ValueKey('username'),
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('empty_title')),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: (_profileData?.coverPhoto != null &&
                              _profileData!.coverPhoto!.isNotEmpty)
                          ? NetworkImage(_profileData!.coverPhoto!)
                              as ImageProvider
                          : const AssetImage(
                              "assets/images/others/elementor-placeholder-image (1).webp"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: (_profileData?.profilePic != null &&
                            _profileData!.profilePic!.isNotEmpty)
                        ? NetworkImage(_profileData!.profilePic!)
                            as ImageProvider
                        : const AssetImage("assets/images/others/Group 69.png"),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -50),
              child: Column(
                children: [
                  // Profile Name
                  if (_profileData != null && _profileData!.username != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        _profileData!.username!,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Menu Items
                  _buildMenuSection(),

                  const SizedBox(height: 30),

                  // Privacy Policy Links Section
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: _buildPrivacyPolicySection()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person_outline,
          title: "Personal Info",
          color: const Color(0xffEB8125),
          onTap: () => Navigator.pushNamed(context, "ProfileEditScreen"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: CupertinoIcons.briefcase,
          title: "Work Preference",
          color: const Color(0xff004673),
          onTap: () => Navigator.pushNamed(context, "WorkPreference"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.category_outlined,
          title: "Preferred Categories",
          color: const Color(0xff004673),
          onTap: () =>
              Navigator.pushNamed(context, "CategoryDropdownFormField"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: CupertinoIcons.globe,
          title: "Language",
          color: const Color(0xffEB8125),
          onTap: () => Navigator.pushNamed(context, "LanguageDropdown"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.school_outlined,
          title: "Educational Information",
          color: const Color(0xff004673),
          onTap: () => Navigator.pushNamed(context, "EducationPage"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.computer_outlined,
          title: "Technical Skills",
          color: const Color(0xffEB8125),
          onTap: () => Navigator.pushNamed(context, "Technicalskill"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.psychology_outlined,
          title: "Soft Skills",
          color: const Color(0xff004673),
          onTap: () => Navigator.pushNamed(context, "SoftSkillScreen"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: CupertinoIcons.briefcase_fill,
          title: "Experience",
          color: const Color(0xff004673),
          onTap: () => Navigator.pushNamed(context, "ShowExperience"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.workspace_premium_outlined,
          title: "Premium",
          color: const Color(0xffEB8125),
          onTap: () => Navigator.pushNamed(context, "PremiumPlansScreen"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: "Additional Information",
          color: const Color(0xffEB8125),
          onTap: () =>
              Navigator.pushNamed(context, "AdditionalInformationScreen"),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.speed_outlined,
          title: "User Plan",
          color: const Color(0xff004673),
          onTap: () => Navigator.pushNamed(context, "PlanUsagePage"),
          isLast: true,
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.lock_reset_outlined,
          title: "Reset Password",
          color: const Color(0xffEB8125),
          onTap: () => _showForgotPasswordDialog(),
          isLast: true,
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.logout_outlined,
          title: "Log Out",
          color: const Color(0xff004673),
          onTap: () => _showLogoutConfirmationDialog(),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isLast ? 20 : 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.grey.shade200,
      indent: 65,
      endIndent: 20,
    );
  }

  // Widget _buildActionButtons() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: _buildActionButton(
  //             icon: Icons.lock_reset_outlined,
  //             title: "Reset Password",
  //             color: const Color(0xffEB8125),
  //             onTap: () => _showForgotPasswordDialog(),
  //           ),
  //         ),
  //         const SizedBox(width: 15),
  //         Expanded(
  //           child: _buildActionButton(
  //             icon: Icons.logout_outlined,
  //             title: "Log Out",
  //             color: const Color(0xff004673),
  //             onTap: () => _showLogoutConfirmationDialog(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Footer Section with Privacy Policy Links
  Widget _buildPrivacyPolicySection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A).withOpacity(0.9),
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(12),
        //   topRight: Radius.circular(12),
        // ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Policy links - ultra compact
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            runSpacing: 4,
            children: [
              _buildFooterLink(
                text: "Privacy Policy",
                url: "https://studentsgigs.com/privacypolicy",
              ),
              _buildFooterDivider(),
              _buildFooterLink(
                text: "Terms & Conditions",
                url: "https://studentsgigs.com/termscondition",
              ),
              _buildFooterDivider(),
              _buildFooterLink(
                text: "Refund Policy",
                url: "https://studentsgigs.com/refundpolicy",
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Copyright text - smaller
          Text(
            "© 2025 Job Portal. All Rights Reserved.",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Powered by text - smallest
          Text(
            "Powered by exmedia",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white.withOpacity(0.5),
              fontSize: 9,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink({
    required String text,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: "Poppins",
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildFooterDivider() {
    return Container(
      width: 1,
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: Colors.white.withOpacity(0.4),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: isLoggingOut
                  ? null
                  : () async {
                      try {
                        await GoogleAuthService.logOut(context);
                      } finally {
                        if (mounted) setState(() => isLoggingOut = false);
                      }
                    },
              child: const Text(
                "Log Out",
                style: TextStyle(color: Color(0xff004673)),
              ),
            ),
          ],
        );
      },
    );
  }

  // Widget _buildActionButton({
  //   required IconData icon,
  //   required String title,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return ElevatedButton(
  //     onPressed: onTap,
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: color,
  //       foregroundColor: Colors.white,
  //       elevation: 0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       padding: const EdgeInsets.symmetric(vertical: 16),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Icon(icon, size: 24),
  //         const SizedBox(height: 8),
  //         Text(
  //           title,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(
  //             fontFamily: "Poppins",
  //             fontWeight: FontWeight.w500,
  //             fontSize: 14,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showForgotPasswordDialog() {
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Enter your new password.",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: password,
                          obscureText: obscureNewPassword,
                          decoration: InputDecoration(
                            labelText: "New password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xffEB8125)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureNewPassword = !obscureNewPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: confirmPassword,
                          obscureText: obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: "Confirm password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xffEB8125)),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                String newPassword = password.text.trim();
                                String confirmPwd = confirmPassword.text.trim();

                                if (newPassword.isEmpty || confirmPwd.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Please fill in all fields."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                if (newPassword != confirmPwd) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Passwords do not match."),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // Call password reset first
                                await passwordResetWithLogin(
                                    newPassword, confirmPwd, context);

                                // Close dialog after API call completes
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }

                                // Clear the text fields
                                password.clear();
                                confirmPassword.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffEB8125),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
