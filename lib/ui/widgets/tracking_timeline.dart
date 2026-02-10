import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../models/order_model.dart';
import '../../utils/formatter.dart';

class TrackingTimeline extends StatelessWidget {
  final List<TrackingHistory> history;
  final bool isDarkMode;

  const TrackingTimeline({
    super.key,
    required this.history,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;

    // Sort history descending by timestamp (newest top)
    final sortedHistory = List<TrackingHistory>.from(history);
    sortedHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedHistory.length,
      itemBuilder: (context, index) {
        final item = sortedHistory[index];
        final isLast = index == sortedHistory.length - 1;
        final isFirst = index == 0;
        return _buildTimelineStep(item, isFirst, isLast, textColor, subTextColor);
      },
    );
  }

  Widget _buildTimelineStep(TrackingHistory item, bool isCurrent, bool isLast, Color textColor, Color subTextColor) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.primary : (isDarkMode ? const Color(0xFF325e67) : Colors.grey.shade300),
                    shape: BoxShape.circle,
                    border: isCurrent ? Border.all(color: isDarkMode ? AppColors.backgroundDark : Colors.white, width: 2) : null,
                  ),
                  child: isCurrent ? Center(child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle))) : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCurrent ? AppColors.primary : (isDarkMode ? const Color(0xFF325e67) : Colors.grey.shade200),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, left: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.status.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isCurrent ? AppColors.primary : textColor)),
                  Text(item.description, style: TextStyle(fontSize: 14, color: subTextColor)),
                  Text(item.location, style: TextStyle(fontSize: 12, color: subTextColor, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 4),
                  Text(AppFormatter.formatDate(item.timestamp), style: const TextStyle(fontSize: 12, color: AppColors.textGray, fontWeight: FontWeight.w500)),
                  if (item.proofUrl != null && item.proofUrl!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.proofUrl!,
                        height: 100,
                        width: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
