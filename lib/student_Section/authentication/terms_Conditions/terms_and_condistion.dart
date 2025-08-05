import 'package:flutter/material.dart';

class TermsAndConditionsDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Terms & Conditions for Students (Job Seekers)",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "StudentsGigs.com - Effective Date: 7/5/2025",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xffEB8125),
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildSectionTitle("1. General Terms"),
                  _buildBulletPoint(
                      "By registering on StudentsGigs.com, you agree to abide by these terms and conditions."),
                  _buildBulletPoint(
                      "StudentsGigs.com serves as a platform connecting students with job opportunities and does not guarantee job placement or employer credibility."),
                  _buildBulletPoint(
                      "StudentsGigs.com is not responsible for salary payments, workplace conditions, or employer actions."),
                  _buildBulletPoint(
                      "Your account may be suspended if found violating these terms."),
                  SizedBox(height: 15),
                  _buildSectionTitle("2. Job Application & Workplace Conduct"),
                  _buildBulletPoint(
                      "You must provide accurate details in your profile and job applications."),
                  _buildBulletPoint(
                      "You must not misrepresent your skills, experience, or qualifications."),
                  _buildBulletPoint(
                      "You are expected to maintain professionalism at all times in the workplace."),
                  _buildBulletPoint(
                      "If an employer asks you to perform illegal, unethical, or unsafe tasks, you must report it to authorities and avoid the job."),
                  SizedBox(height: 15),
                  _buildSectionTitle("3. Salary, Payments & Disputes"),
                  _buildBulletPoint(
                      "StudentsGigs.com is not responsible for salary payments, deductions, or delays."),
                  _buildBulletPoint(
                      "Employers are directly responsible for paying students for their work."),
                  _buildBulletPoint(
                      "In case of non-payment, the student must resolve the issue with the employer."),
                  _buildBulletPoint(
                      "StudentsGigs.com does not guarantee employer compliance in making payments."),
                  SizedBox(height: 15),
                  _buildSectionTitle("4. Workplace Conditions & Safety"),
                  _buildBulletPoint(
                      "StudentsGigs.com does not verify the safety, legality, or working conditions of jobs."),
                  _buildBulletPoint(
                      "You are advised to research the employer and workplace before accepting a job."),
                  _buildBulletPoint(
                      "If you face harassment, discrimination, or unsafe conditions, you should report it to the authorities immediately."),
                  _buildBulletPoint(
                      "StudentsGigs.com is not liable for any physical, emotional, or legal harm experienced at a workplace."),
                  SizedBox(height: 15),
                  _buildSectionTitle("5. Privacy & Data Protection"),
                  _buildBulletPoint(
                      "Your contact details must only be shared for job-related purposes."),
                  _buildBulletPoint(
                      "Employers are prohibited from misusing your personal data, but StudentsGigs.com cannot guarantee their compliance."),
                  _buildBulletPoint(
                      "Do not share login credentials or personal details with third parties."),
                  SizedBox(height: 15),
                  _buildSectionTitle("6. Termination of Account"),
                  Text(
                    "Your account may be suspended or banned for any of the following:",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  _buildSubBulletPoint(
                      "Providing false information in your profile."),
                  _buildSubBulletPoint(
                      "Misbehaving with employers, staff, or co-workers."),
                  _buildSubBulletPoint(
                      "Engaging in fraudulent activities using the platform."),
                  _buildSubBulletPoint(
                      "Using the platform for non-job-related purposes."),
                  SizedBox(height: 15),
                  _buildSectionTitle("7. Legal Disclaimer"),
                  _buildBulletPoint(
                      "StudentsGigs.com is a platform provider and is not responsible for employer actions, payments, or workplace conditions."),
                  _buildBulletPoint(
                      "Students must do their due diligence before accepting jobs."),
                  _buildBulletPoint(
                      "Any disputes must be resolved between the student and employer."),
                  SizedBox(height: 15),
                  _buildSectionTitle("8. Agreement & Acknowledgment"),
                  _buildBulletPoint(
                      "By registering, you agree to these terms and acknowledge that StudentsGigs.com is not responsible for employment-related disputes."),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xffF9F2ED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xffEB8125), width: 1),
                    ),
                    child: Text(
                      "Note: These terms and conditions are designed to protect both students and employers, ensuring a fair and safe environment on StudentsGigs.com.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff004673),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Close",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Color(0xffEB8125),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xff004673),
        ),
      ),
    );
  }

  static Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffEB8125),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSubBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4, left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "◦ ",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xffEB8125),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
