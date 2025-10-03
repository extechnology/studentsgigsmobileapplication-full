import 'package:anjalim/student_Section/custom_widgets/dateformating.dart';
import 'package:anjalim/student_Section/services/popularjobs.dart';
import 'package:anjalim/student_Section/student_Screens/applyjob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart'
    show Margins, Style, Html, FontSize, HtmlPaddings;

class GigsDetailScreen extends StatelessWidget {
  const GigsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // print("JobData---$args");

    final jobData = args['jobData'] as Map<String, dynamic>? ?? args;
    final jobId = jobData['id']?.toString() ?? '';
    final jobTitle = jobData['job_title'] ?? jobData['position'] ?? 'No Title';
    final jobLocation =
        jobData['job_location'] ?? jobData['location'] ?? 'Remote';
    final jobType = jobData['job_type'] ?? jobData['jobType'] ?? 'Unknown';
    final payStructure =
        jobData['pay_structure'] ?? jobData['salary'] ?? 'Not specified';
    final salaryType = jobData['salary_type'] ?? jobData['salaryType'] ?? '';
    final postedDate = jobData['posted_date'] ?? '';
    final applied = jobData["applied"] ?? false;
    final saved = jobData["saved_job"] ?? false;
    final employerId = jobData['employerId'] ?? '';
    final totalApplied = jobData['total_applied'] ?? 0;
    final priority = jobData['priority'] ?? 0;
    final jobDescription =
        jobData['job_description'] ?? jobData['description'] ?? '';

    // Company data - handle both Map and String cases
    final company = jobData['company'];
    final companyName = company is Map<String, dynamic>
        ? (company['company_name'] ?? 'Unknown Company')
        : (company?.toString() ?? 'Unknown Company');
    final companyLogo = company is Map<String, dynamic>
        ? (company['logo'] ?? jobData['logo'] ?? '')
        : (jobData['logo'] ?? '');
    final companyId = company is Map<String, dynamic>
        ? (company['id']?.toString() ?? '')
        : '';

    // Additional company details
    final companyInfo =
        company is Map<String, dynamic> ? (company['company_info'] ?? '') : '';
    final companyEmail =
        company is Map<String, dynamic> ? (company['email'] ?? '') : '';
    final companyPhone =
        company is Map<String, dynamic> ? (company['phone_number'] ?? '') : '';
    final companyAddress =
        company is Map<String, dynamic> ? _formatAddress(company) : '';

    // Job details that might come from backend
    final requirements = jobData['requirements'] ?? '';
    final responsibilities = jobData['responsibilities'] ?? '';
    final benefits = jobData['benefits'] ?? '';
    final experience = jobData['experience'] ?? '';
    final qualification = jobData['qualification'] ?? '';
    final companyDescription = jobData['company_description'] ??
        (company is Map<String, dynamic> ? (company['description'] ?? '') : '');

    final JobService _jobService = JobService();

    // HTML styling configuration
    // HTML styling configuration
    final htmlStyle = {
      "body": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero, // Changed to HtmlPaddings
        fontFamily: "Poppins",
        fontSize: FontSize(14.0),
        fontWeight: FontWeight.w300,
        color: Color(0xff000000),
      ),
      "h1": Style(
        fontFamily: "Poppins",
        fontSize: FontSize(18.0),
        fontWeight: FontWeight.w600,
        color: Color(0xff000000),
        margin: Margins.only(bottom: 10, top: 10),
        padding: HtmlPaddings.zero, // Added padding
      ),
      "h2": Style(
        fontFamily: "Poppins",
        fontSize: FontSize(16.0),
        fontWeight: FontWeight.w600,
        color: Color(0xff000000),
        margin: Margins.only(bottom: 10, top: 10),
        padding: HtmlPaddings.zero, // Added padding
      ),
      "p": Style(
        margin: Margins.only(bottom: 10),
        padding: HtmlPaddings.zero, // Added padding
      ),
      "strong": Style(
        fontWeight: FontWeight.bold,
      ),
      "em": Style(
        fontStyle: FontStyle.italic,
      ),
      "ul": Style(
        margin: Margins.only(bottom: 10),
        padding: HtmlPaddings.zero, // Added padding
      ),
      "li": Style(
        margin: Margins.only(bottom: 5),
        padding: HtmlPaddings.zero, // Added padding
      ),
    };

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xffF9F2ED),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffF9F2ED),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Image.asset(
            "assets/images/logos/image 1.png",
            height: 60,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status indicators row
                  Row(
                    children: [
                      // Applied status indicator
                      if (applied)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xff004673),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Applied',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      // Priority indicator
                      if (priority > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Priority ${priority}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  if (applied || saved || priority > 0)
                    const SizedBox(height: 10),

                  // Job Title
                  Text(
                    jobTitle,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      color: Color(0xff3F414E),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Job Details
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14, top: 14),
                    child: Column(
                      children: [
                        // Location
                        if (jobLocation.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 24, color: Colors.red),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    jobLocation,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Job Type
                        if (jobType.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.work_outline,
                                    size: 24, color: Color(0xff000000)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff9FEBA8),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    jobType,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Experience
                        if (experience.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.work_history_outlined,
                                    size: 24, color: Color(0xff000000)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    experience,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Posted Date
                        if (postedDate.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined,
                                    size: 24, color: Color(0xff000000)),
                                const SizedBox(width: 8),
                                Text(
                                  "Posted: ${formatPostedDate(postedDate)}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Salary
                        if (payStructure.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.money,
                                    size: 24, color: Color(0xff000000)),
                                const SizedBox(width: 8),
                                Text(
                                  salaryType.isNotEmpty
                                      ? "₹$payStructure - $salaryType"
                                      : "₹$payStructure",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Total Applied
                        if (totalApplied > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.people_outline,
                                    size: 24, color: Color(0xff000000)),
                                const SizedBox(width: 8),
                                Text(
                                  "$totalApplied applicants",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Job Description Section
                  if (jobDescription.isNotEmpty) ...[
                    Text(
                      "Job Description",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10.8),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4), // Using EdgeInsets for Container
                      child: Html(
                        data: jobDescription,
                        style: htmlStyle,
                        shrinkWrap: true,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],

                  // Company Info Section
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: companyLogo.isNotEmpty
                            ? NetworkImage(companyLogo)
                            : null,
                        child: companyLogo.isEmpty
                            ? const Icon(Icons.business, size: 30)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companyName.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            if (companyAddress.isNotEmpty)
                              Text(
                                companyAddress,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Company Contact Information
                  if (companyEmail.isNotEmpty || companyPhone.isNotEmpty) ...[
                    const Text(
                      "Company Contact",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (companyEmail.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () async {
                            final Uri emailUri = Uri(
                              scheme: 'mailto',
                              path: companyEmail,
                            );
                            try {
                              if (await canLaunchUrl(emailUri)) {
                                await launchUrl(emailUri);
                              } else {
                                throw 'Could not launch email client';
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.email_outlined,
                                  size: 20, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  companyEmail,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (companyPhone.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () async {
                            final Uri phoneUri = Uri(
                              scheme: 'tel',
                              path: companyPhone,
                            );
                            try {
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              } else {
                                throw 'Could not launch phone dialer';
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.phone_outlined,
                                  size: 20, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  companyPhone,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                  // Responsibilities Section
                  if (responsibilities.isNotEmpty) ...[
                    const Text(
                      "Responsibilities",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10.8),
                    Text(
                      responsibilities,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Requirements Section
                  if (requirements.isNotEmpty) ...[
                    const Text(
                      "Requirements",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10.8),
                    Text(
                      requirements,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Qualifications Section
                  if (qualification.isNotEmpty) ...[
                    const Text(
                      "Qualifications",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10.8),
                    Text(
                      qualification,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Benefits Section
                  if (benefits.isNotEmpty) ...[
                    const Text(
                      "Benefits",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10.8),
                    Text(
                      benefits,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff000000),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Apply Button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: 107,
                      height: 56,
                      child: FloatingActionButton(
                        onPressed: applied
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ApplyForJobScreen(
                                      jobId: jobId,
                                      jobTitle: jobTitle,
                                      companyName: companyName,
                                      jobType: jobType,
                                    ),
                                  ),
                                );
                              },
                        child: Text(
                          applied ? "Applied" : "Apply",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        backgroundColor:
                            applied ? Colors.blueGrey : const Color(0xff004673),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to format company address
  static String _formatAddress(Map<String, dynamic> company) {
    List<String> addressParts = [];

    if (company['street_address'] != null &&
        company['street_address'].toString().isNotEmpty) {
      addressParts.add(company['street_address'].toString());
    }
    if (company['city'] != null && company['city'].toString().isNotEmpty) {
      addressParts.add(company['city'].toString());
    }
    if (company['state'] != null && company['state'].toString().isNotEmpty) {
      addressParts.add(company['state'].toString());
    }
    if (company['postal_code'] != null &&
        company['postal_code'].toString().isNotEmpty) {
      addressParts.add(company['postal_code'].toString());
    }

    return addressParts.join(', ');
  }
}
