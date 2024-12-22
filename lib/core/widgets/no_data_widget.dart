import 'package:education_app/core/helpers/context_extension.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String? message;
  final String? subMessage;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final String? buttonText;
  final VoidCallback? onRefresh;

  const NoDataWidget({
    super.key,
    this.message = 'No Data Available',
    this.subMessage,
    this.icon = Icons.inbox_outlined,
    this.iconColor,
    this.iconSize,
    this.buttonText,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize ?? 100,
            color: iconColor ?? Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (subMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              subMessage!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (onRefresh != null) ...[
            const SizedBox(height: 16),
            MainButton(
                text: buttonText ?? 'Refresh',
                width: context.width / 2.9,
                onTap: onRefresh!)
          ],
        ],
      ),
    );
  }
}
