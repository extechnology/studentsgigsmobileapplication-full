import 'package:anjalim/student_Section/services/apiconstant.dart';
import 'package:anjalim/student_Section/services/popularjobs.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/premiumplan1.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApplyForJobScreen extends StatefulWidget {
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String jobType;

  const ApplyForJobScreen({
    Key? key,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.jobType,
  }) : super(key: key);

  @override
  State<ApplyForJobScreen> createState() => _ApplyForJobScreenState();
}

class _ApplyForJobScreenState extends State<ApplyForJobScreen> {
  PlatformFile? _resumeFile;
  bool _isLoading = false;
  Map<String, dynamic>? _userPlanData;
  List<dynamic>? _availablePlans;
  bool _isCheckingPlan = true;
  final PlanService _planService = PlanService();

  @override
  void initState() {
    super.initState();
    _checkUserPlanStatus();
  }

  Future<void> _checkUserPlanStatus() async {
    setState(() => _isCheckingPlan = true);

    try {
      // Fetch current user plan status using PlanService
      _userPlanData = await _planService.fetchUserPlans();

      // Debug: Print the actual structure

      // Fetch available plans for upgrade
      _availablePlans = await fetchUserPremiumPlans();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking plan status: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isCheckingPlan = false);
    }
  }

  bool _canApplyForJob() {
    if (_userPlanData == null) {
      return false;
    }

    try {
      // Direct check for job_limit
      if (_userPlanData!.containsKey('job_limit')) {
        bool jobLimit = _userPlanData!['job_limit'] == true;
        if (jobLimit) return true;
      }

      // Check nested current_plan
      if (_userPlanData!.containsKey('current_plan')) {
        var currentPlan = _userPlanData!['current_plan'];

        // Make sure current_plan is a Map, not a List or String
        if (currentPlan is Map<String, dynamic>) {
          if (currentPlan.containsKey('job_limit')) {
            bool nestedJobLimit = currentPlan['job_limit'] == true;
            return nestedJobLimit;
          }
        } else if (currentPlan is List) {
          // Handle if current_plan is a list - check first item if it exists
          if (currentPlan.isNotEmpty &&
              currentPlan[0] is Map<String, dynamic>) {
            var firstPlan = currentPlan[0] as Map<String, dynamic>;
            if (firstPlan.containsKey('job_limit')) {
              return firstPlan['job_limit'] == true;
            }
          }
        }
      }

      // Check nested usage object
      if (_userPlanData!.containsKey('usage')) {
        var usage = _userPlanData!['usage'];
        if (usage is Map<String, dynamic> && usage.containsKey('job_limit')) {
          return usage['job_limit'] == true;
        }
      }

      // Additional checks for different API response structures
      if (_userPlanData!.containsKey('plan')) {
        var plan = _userPlanData!['plan'];
        if (plan is Map<String, dynamic> && plan.containsKey('job_limit')) {
          return plan['job_limit'] == true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  bool _isProfileCompleted() {
    if (_userPlanData == null) {
      return false;
    }

    try {
      // Check nested usage object first
      if (_userPlanData!.containsKey('usage')) {
        var usage = _userPlanData!['usage'];
        if (usage is Map<String, dynamic> &&
            usage.containsKey('profile_completed')) {
          bool profileCompleted = usage['profile_completed'] == true;
          return profileCompleted;
        }
      }

      // Direct check for profile_completed
      if (_userPlanData!.containsKey('profile_completed')) {
        bool profileCompleted = _userPlanData!['profile_completed'] == true;
        return profileCompleted;
      }

      // Check nested current_plan
      if (_userPlanData!.containsKey('current_plan')) {
        var currentPlan = _userPlanData!['current_plan'];
        if (currentPlan is Map<String, dynamic> &&
            currentPlan.containsKey('profile_completed')) {
          return currentPlan['profile_completed'] == true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  bool _isAgeValid() {
    if (_userPlanData == null) {
      return false;
    }

    try {
      // Check nested usage object first
      if (_userPlanData!.containsKey('usage')) {
        var usage = _userPlanData!['usage'];
        if (usage is Map<String, dynamic> &&
            usage.containsKey('age_restrict')) {
          bool ageValid = usage['age_restrict'] == true;
          return ageValid;
        }
      }

      // Direct check for age_restrict
      if (_userPlanData!.containsKey('age_restrict')) {
        bool ageValid = _userPlanData!['age_restrict'] == true;
        return ageValid;
      }

      // Check nested current_plan
      if (_userPlanData!.containsKey('current_plan')) {
        var currentPlan = _userPlanData!['current_plan'];
        if (currentPlan is Map<String, dynamic> &&
            currentPlan.containsKey('age_restrict')) {
          return currentPlan['age_restrict'] == true;
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  String _getRestrictionMessage() {
    if (!_isProfileCompleted() && !_isAgeValid()) {
      return 'Complete your profile and you must be above 14 years old to apply';
    } else if (!_isProfileCompleted()) {
      return 'Please complete your profile to apply for jobs';
    } else if (!_isAgeValid()) {
      return 'You must be above 14 years old to apply for jobs';
    } else if (!_canApplyForJob()) {
      return 'Job application limit reached for ${_getCurrentPlanName()} plan';
    }
    return '';
  }

  bool _canUserApply() {
    return _isProfileCompleted() && _isAgeValid() && _canApplyForJob();
  }

  String _getCurrentPlanName() {
    if (_userPlanData == null) return 'Unknown';

    try {
      // Try different possible keys for plan name
      List<String> possibleKeys = [
        'plan_name',
        'name',
        'current_plan.name',
        'current_plan.plan_name',
        'plan.name',
        'plan.plan_name'
      ];

      // Direct keys first
      if (_userPlanData!.containsKey('plan_name')) {
        return _userPlanData!['plan_name']?.toString() ?? 'Unknown';
      }

      if (_userPlanData!.containsKey('name')) {
        return _userPlanData!['name']?.toString() ?? 'Unknown';
      }

      // Check nested current_plan
      if (_userPlanData!.containsKey('current_plan')) {
        var currentPlan = _userPlanData!['current_plan'];

        if (currentPlan is Map<String, dynamic>) {
          if (currentPlan.containsKey('name')) {
            return currentPlan['name']?.toString() ?? 'Unknown';
          }
          if (currentPlan.containsKey('plan_name')) {
            return currentPlan['plan_name']?.toString() ?? 'Unknown';
          }
        } else if (currentPlan is List && currentPlan.isNotEmpty) {
          var firstPlan = currentPlan[0];
          if (firstPlan is Map<String, dynamic>) {
            if (firstPlan.containsKey('name')) {
              return firstPlan['name']?.toString() ?? 'Unknown';
            }
            if (firstPlan.containsKey('plan_name')) {
              return firstPlan['plan_name']?.toString() ?? 'Unknown';
            }
          }
        }
      }

      // Check nested plan
      if (_userPlanData!.containsKey('plan')) {
        var plan = _userPlanData!['plan'];
        if (plan is Map<String, dynamic>) {
          if (plan.containsKey('name')) {
            return plan['name']?.toString() ?? 'Unknown';
          }
          if (plan.containsKey('plan_name')) {
            return plan['plan_name']?.toString() ?? 'Unknown';
          }
        }
      }

      return 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  Future<List<dynamic>> fetchUserPremiumPlans() async {
    final FlutterSecureStorage _storage = FlutterSecureStorage();
    String _baseUrl = '${ApiConstants.baseUrl}api/employee/';
    const String endpoint = 'all-plans/';
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
        //print("Response ---${response.body}");

        final decodedResponse = json.decode(response.body);

        // Handle different response structures
        if (decodedResponse is List) {
          return decodedResponse;
        } else if (decodedResponse is Map<String, dynamic>) {
          // Check for common API response patterns
          if (decodedResponse.containsKey('data')) {
            var data = decodedResponse['data'];
            return data is List ? data : [data];
          } else if (decodedResponse.containsKey('results')) {
            var results = decodedResponse['results'];
            return results is List ? results : [results];
          } else if (decodedResponse.containsKey('plans')) {
            var plans = decodedResponse['plans'];
            return plans is List ? plans : [plans];
          } else {
            return [decodedResponse];
          }
        }
        return [];
      } else {
        throw Exception('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plan data: ${e.toString()}');
    }
  }

  List<dynamic> _getUpgradePlans() {
    if (_availablePlans == null || _userPlanData == null) return [];

    try {
      String currentPlan = _getCurrentPlanName().toLowerCase();

      // Filter plans based on current plan
      return _availablePlans!.where((plan) {
        if (plan is! Map<String, dynamic>) return false;

        String planName = '';
        if (plan.containsKey('name')) {
          planName = plan['name']?.toString().toLowerCase() ?? '';
        } else if (plan.containsKey('plan_name')) {
          planName = plan['plan_name']?.toString().toLowerCase() ?? '';
        }

        // If user is on free plan, show standard and premium
        if (currentPlan.contains('free')) {
          return planName.contains('standard') || planName.contains('premium');
        }
        // If user is on standard plan, show only premium
        else if (currentPlan.contains('standard')) {
          return planName.contains('premium');
        }
        // If user is on premium, no upgrades available
        return false;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  void _showRestrictionDialog() {
    if (!_isProfileCompleted() || !_isAgeValid()) {
      _showProfileAgeRestrictionDialog();
    } else if (!_canApplyForJob()) {
      _showUpgradePlanDialog();
    }
  }

  void _showProfileAgeRestrictionDialog() {
    String title = '';
    String message = '';
    String actionText = '';
    VoidCallback? actionCallback;

    if (!_isProfileCompleted() && !_isAgeValid()) {
      title = 'Profile and Age Restrictions';
      message =
          'To apply for jobs, you need to:\n\n• Complete your profile\n• Be above 14 years old';
      actionText = 'Complete Profile';
      actionCallback = _navigateToProfilePage;
    } else if (!_isProfileCompleted()) {
      title = 'Profile Incomplete';
      message = 'Please complete your profile to apply for jobs.';
      actionText = 'Complete Profile';
      actionCallback = _navigateToProfilePage;
    } else if (!_isAgeValid()) {
      title = 'Age Restriction';
      message = 'You must be above 14 years old to apply for jobs.';
      actionText = 'Update Age';
      actionCallback = _navigateToProfilePage;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(fontFamily: "Poppins"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (actionCallback != null) actionCallback();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff004673),
              ),
              child: Text(
                actionText,
                style: TextStyle(fontFamily: "Poppins"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUpgradePlanDialog() {
    List<dynamic> upgradePlans = _getUpgradePlans();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Job Application Limit Reached',
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have reached your job application limit for the ${_getCurrentPlanName()} plan.',
                style: TextStyle(fontFamily: "Poppins"),
              ),
              SizedBox(height: 16),
              if (upgradePlans.isNotEmpty) ...[
                Text(
                  'Upgrade to apply for more jobs:',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                ...upgradePlans.map((plan) {
                  if (plan is! Map<String, dynamic>) return SizedBox.shrink();

                  String planName = plan['name']?.toString() ??
                      plan['plan_name']?.toString() ??
                      'Plan';
                  String planPrice = plan['price']?.toString() ?? 'N/A';

                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(
                        planName,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Price: \$$planPrice',
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToUpgradePage(plan);
                      },
                    ),
                  );
                }).toList(),
              ] else ...[
                Text(
                  'You are already on the highest plan available.',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.grey[600],
                  ),
                ),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.grey,
                ),
              ),
            ),
            if (upgradePlans.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigateToPlansPage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff004673),
                ),
                child: Text(
                  'View Plans',
                  style: TextStyle(fontFamily: "Poppins"),
                ),
              ),
          ],
        );
      },
    );
  }

  void _navigateToProfilePage() {
    // Navigate to profile completion page
    // Replace with your actual navigation logic
    Navigator.pushNamed(context, "ProfileEditScreen");

    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  void _navigateToUpgradePage(Map<String, dynamic> plan) {
    Navigator.pushNamed(context, "PremiumScreen");
    // Navigate to specific plan upgrade page
    // Replace with your actual navigation logic
    // Navigator.push(context, MaterialPageRoute(builder: (context) => UpgradePlanScreen(plan: plan)));
  }

  void _navigateToPlansPage() {
    // Navigate to plans page
    // Replace with your actual navigation logic
    Navigator.pushNamed(context, "PremiumScreen");
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PlansScreen()));
  }

  Future<void> _pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _resumeFile = result.files.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _submitApplication(bool withResume) async {
    final _refresh = JobService();
    // Check if user can apply for job (all restrictions)
    if (!_canUserApply()) {
      _showRestrictionDialog();
      return;
    }

    setState(() => _isLoading = true);
    final _storage = FlutterSecureStorage();

    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}api/employee/job-application/'),
      );

      // Add authorization header
      String? token = await _storage.read(key: 'access_token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add form fields
      request.fields['job_id'] = widget.jobId;
      request.fields['job_type'] = widget.jobType;

      // Add resume file if needed
      if (withResume && _resumeFile != null) {
        // Create multipart file from the selected file
        request.files.add(
          await http.MultipartFile.fromPath(
            'resume', // This must match your backend's expected field name
            _resumeFile!.path!,
            filename: _resumeFile!.name,
          ),
        );
      }

      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh plan status after successful application
        await _checkUserPlanStatus();

        Navigator.pop(context);
      } else {
        throw Exception('Failed to submit application (${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit application: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F2ED),
      appBar: AppBar(
        title: Text(
          'Apply for Job',
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xffF9F2ED),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isCheckingPlan
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xff004673)),
                  SizedBox(height: 16),
                  Text(
                    'Checking plan status...',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.jobTitle,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.companyName,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 10),

                  // Plan status indicator
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _canUserApply()
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _canUserApply() ? Colors.green : Colors.red,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _canUserApply() ? Icons.check_circle : Icons.warning,
                          size: 16,
                          color: _canUserApply() ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _canUserApply()
                                ? '${_getCurrentPlanName()} Plan - Can Apply'
                                : _getRestrictionMessage(),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: _canUserApply()
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Resume Upload Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload Resume',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Supported formats: PDF, DOC, DOCX',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 20),
                          if (_resumeFile != null)
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.insert_drive_file,
                                        color: Colors.blue),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _resumeFile!.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () =>
                                          setState(() => _resumeFile = null),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ElevatedButton(
                            onPressed: _canUserApply() ? _pickResume : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _canUserApply()
                                  ? Color(0xff004673)
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              _resumeFile == null
                                  ? 'Select Resume'
                                  : 'Change Resume',
                              style: TextStyle(fontFamily: "Poppins"),
                            ),
                          ),
                          SizedBox(height: 20),
                          if (_resumeFile != null)
                            ElevatedButton(
                              onPressed: (_isLoading || !_canUserApply())
                                  ? null
                                  : () => _submitApplication(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _canUserApply()
                                    ? Colors.green
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      'Submit with Resume',
                                      style: TextStyle(fontFamily: "Poppins"),
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Apply without resume option or show restriction message
                  if (!_canUserApply()) ...[
                    Center(
                      child: ElevatedButton(
                        onPressed: _showRestrictionDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff004673),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          !_isProfileCompleted() || !_isAgeValid()
                              ? 'Complete Requirements'
                              : 'Upgrade Plan to Apply',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: TextButton(
                        onPressed:
                            _isLoading ? null : () => _submitApplication(false),
                        child: Text(
                          'Apply without Resume',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            color: Color(0xff004673),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
