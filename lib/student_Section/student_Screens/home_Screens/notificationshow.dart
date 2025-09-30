import 'package:anjalim/student_Section/services/notification.dart';
import 'package:flutter/material.dart';

void showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return NotificationDialogContent();
    },
  );
}

class NotificationDialogContent extends StatefulWidget {
  const NotificationDialogContent({Key? key}) : super(key: key);

  @override
  State<NotificationDialogContent> createState() =>
      _NotificationDialogContentState();
}

class _NotificationDialogContentState extends State<NotificationDialogContent> {
  final NotificationService _notificationService = NotificationService();
  late Future<List<dynamic>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _notificationService.fetchnotification();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: FutureBuilder<List<dynamic>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            // Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(
                      color: Color(0xffEB8125),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Loading notifications...",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Error state
            if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Failed to load notifications",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffEB8125),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            }

            // Empty state
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      size: 50,
                      color: Color(0xffEB8125),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No notifications yet",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "We'll notify you when something important happens.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffEB8125),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            }

            // Success state with notifications
            final notifications = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffEB8125).withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Notifications",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                // Notifications List
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[300],
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationItem(notification: notification);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final dynamic notification;

  const NotificationItem({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Adjust these field names based on your actual API response structure
    final String title = notification['title'] ?? 'Notification';
    final String message = notification['message'] ?? '';
    final String time = notification['created_at'] ?? '';
    final bool isRead = notification['is_read'] ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isRead
                  ? Colors.grey[200]
                  : const Color(0xffEB8125).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.notifications,
              size: 24,
              color: isRead ? Colors.grey[600] : const Color(0xffEB8125),
            ),
          ),
          const SizedBox(width: 12),
          // Notification Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(time),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Unread Indicator
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, left: 8),
              decoration: const BoxDecoration(
                color: Color(0xffEB8125),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 7) {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateTimeString;
    }
  }
}
