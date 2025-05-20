import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/ui_constants.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: UiConstants.spaceXS,
          horizontal: UiConstants.spaceS,
        ),
        padding: EdgeInsets.symmetric(
          vertical: UiConstants.spaceM,
          horizontal: UiConstants.spaceM,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.userMessageColor : AppColors.botMessageColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? UiConstants.radiusL : UiConstants.radiusS),
            topRight: Radius.circular(isUser ? UiConstants.radiusS : UiConstants.radiusL),
            bottomLeft: Radius.circular(UiConstants.radiusL),
            bottomRight: Radius.circular(UiConstants.radiusL),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: isUser
                  ? AppTextStyles.userMessageText
                  : AppTextStyles.botMessageText,
            ),
            SizedBox(height: UiConstants.spaceXS),
            Text(
              _formatTime(timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white.withOpacity(0.7) : AppColors.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.year == time.year && now.month == time.month && now.day == time.day) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}