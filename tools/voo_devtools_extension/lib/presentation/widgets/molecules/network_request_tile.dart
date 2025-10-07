import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/network_request_model.dart';
import 'package:voo_devtools_extension/presentation/widgets/atoms/duration_badge.dart';
import 'package:voo_devtools_extension/presentation/widgets/atoms/method_badge.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import 'package:voo_devtools_extension/presentation/widgets/molecules/modern_list_tile.dart';

class NetworkRequestTile extends StatelessWidget {
  final NetworkRequestModel request;
  final bool selected;
  final VoidCallback onTap;

  const NetworkRequestTile({
    super.key,
    required this.request,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uri = Uri.tryParse(request.url);
    final path = uri?.path ?? request.url;
    final host = uri?.host ?? '';

    // Determine status color for the tile
    Color? selectedColor;
    if (request.error != null) {
      selectedColor = Colors.red;
    } else if (request.statusCode != null && request.statusCode! >= 400) {
      selectedColor = Colors.orange;
    } else if (request.isInProgress) {
      selectedColor = Colors.blue;
    }

    return ModernListTile(
      isSelected: selected,
      selectedColor: selectedColor,
      onTap: onTap,
      leading: MethodBadge(method: request.method, compact: true),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  path.isEmpty ? '/' : path,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (request.isInProgress) ...[
                _buildLoadingIndicator(theme),
              ] else if (request.statusCode != null) ...[
                VooStatusBadge(statusCode: request.statusCode!, compact: true),
              ] else if (request.error != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'ERROR',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (host.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              host,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.schedule,
            size: 12,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Text(
            _formatTime(request.timestamp),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
          if (request.duration != null && !request.isInProgress) ...[
            const SizedBox(width: 12),
            DurationBadge(milliseconds: request.duration!, showIcon: false),
          ],
          if (request.displaySize != '-') ...[
            const SizedBox(width: 12),
            Icon(
              Icons.data_usage,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Text(
              request.displaySize,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    final hasTimedOut = request.hasTimedOut;
    final color = hasTimedOut ? Colors.orange : Colors.blue;
    final text = hasTimedOut ? 'Timeout' : 'Pending';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hasTimedOut) ...[
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            ),
          ] else ...[
            Icon(
              Icons.timer_off_outlined,
              size: 12,
              color: color,
            ),
          ],
          const SizedBox(width: 6),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
