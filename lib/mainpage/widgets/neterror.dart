import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  final String title;
  final String message;
  // final VoidCallback onRetry; // Uncomment if you want retry button

  const NoInternetWidget({
    super.key,
    this.title = "Oops! We couldn’t load right now.",
    this.message = "Please check your network availability.",
    // required this.onRetry, // Uncomment if needed
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        width: width * 0.9,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.01,
          vertical: height * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top warning icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: width * 0.13,
                color: Colors.red,
              ),
            ),
            SizedBox(height: height * 0.02),

            // Bold title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.05,
                fontWeight: FontWeight.w700,
                color: Colors.redAccent,
              ),
            ),

            SizedBox(height: height * 0.014),

            // Subtitle / message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.035, // made responsive
                color: Colors.black54,
              ),
            ),

            SizedBox(height: height * 0.014),

            // Retry button (optional)
            // ElevatedButton(
            //   onPressed: onRetry,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color(0xffEB8125),
            //     padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: const Text(
            //     "Retry",
            //     style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 15,
            //         fontWeight: FontWeight.w600),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
