import 'package:flutter/material.dart';
import 'package:voo_tokens/voo_tokens.dart';

/// Modern user profile footer for navigation drawer/rail
/// Displays user avatar, name, email with dropdown actions
class VooUserProfileFooter extends StatefulWidget {
  /// User's display name
  final String? userName;

  /// User's email address
  final String? userEmail;

  /// User's avatar image URL or asset path
  final String? avatarUrl;

  /// Custom avatar widget (overrides avatarUrl)
  final Widget? avatarWidget;

  /// Initials to show if no avatar is provided
  final String? initials;

  /// Whether the profile is in compact mode (rail collapsed)
  final bool compact;

  /// Callback when profile is tapped
  final VoidCallback? onTap;

  /// Callback when settings icon is tapped
  final VoidCallback? onSettingsTap;

  /// Callback when logout is requested
  final VoidCallback? onLogout;

  /// Custom dropdown menu items
  final List<VooProfileMenuItem>? menuItems;

  /// Status indicator (online, away, busy, offline)
  final VooUserStatus? status;

  /// Whether to show the chevron/dropdown indicator
  final bool showDropdownIndicator;

  const VooUserProfileFooter({
    super.key,
    this.userName,
    this.userEmail,
    this.avatarUrl,
    this.avatarWidget,
    this.initials,
    this.compact = false,
    this.onTap,
    this.onSettingsTap,
    this.onLogout,
    this.menuItems,
    this.status,
    this.showDropdownIndicator = true,
  });

  @override
  State<VooUserProfileFooter> createState() => _VooUserProfileFooterState();
}

class _VooUserProfileFooterState extends State<VooUserProfileFooter> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.vooSpacing;
    final radius = context.vooRadius;
    final isDark = theme.brightness == Brightness.dark;

    if (widget.compact) {
      return _buildCompactProfile(context, theme, spacing, radius, isDark);
    }

    return _buildExpandedProfile(context, theme, spacing, radius, isDark);
  }

  Widget _buildCompactProfile(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    dynamic radius,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.all(spacing.sm),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Tooltip(
            message: widget.userName ?? 'Profile',
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(spacing.xs),
              decoration: BoxDecoration(
                color: _isHovered
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(radius.md),
              ),
              child: _buildAvatar(context, theme, 36),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedProfile(
    BuildContext context,
    ThemeData theme,
    dynamic spacing,
    dynamic radius,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.sm),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap ?? () => _showProfileMenu(context),
            borderRadius: BorderRadius.circular(radius.md),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.sm,
                vertical: spacing.sm,
              ),
              decoration: BoxDecoration(
                color: _isHovered
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(radius.md),
                border: _isHovered
                    ? Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                        width: 1,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  _buildAvatar(context, theme, 40),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.userName ?? 'User',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.userEmail != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            widget.userEmail!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (widget.showDropdownIndicator)
                    AnimatedRotation(
                      turns: _isHovered ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, ThemeData theme, double size) {
    final radius = context.vooRadius;

    Widget avatarContent;

    if (widget.avatarWidget != null) {
      avatarContent = widget.avatarWidget!;
    } else if (widget.avatarUrl != null) {
      avatarContent = ClipRRect(
        borderRadius: BorderRadius.circular(radius.md),
        child: Image.network(
          widget.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildInitialsAvatar(context, theme, size),
        ),
      );
    } else {
      avatarContent = _buildInitialsAvatar(context, theme, size);
    }

    return Stack(
      children: [
        avatarContent,
        if (widget.status != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: _buildStatusIndicator(theme),
          ),
      ],
    );
  }

  Widget _buildInitialsAvatar(
      BuildContext context, ThemeData theme, double size) {
    final radius = context.vooRadius;
    final initials = widget.initials ??
        (widget.userName?.isNotEmpty == true
            ? widget.userName!
                .split(' ')
                .take(2)
                .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
                .join()
            : '?');

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radius.md),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(ThemeData theme) {
    final color = switch (widget.status) {
      VooUserStatus.online => const Color(0xFF22C55E),
      VooUserStatus.away => const Color(0xFFF59E0B),
      VooUserStatus.busy => const Color(0xFFEF4444),
      VooUserStatus.offline => theme.colorScheme.outline,
      null => Colors.transparent,
    };

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 2,
        ),
        boxShadow: widget.status == VooUserStatus.online
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final theme = Theme.of(context);
    final radius = context.vooRadius;

    final defaultItems = [
      VooProfileMenuItem(
        icon: Icons.person_outline_rounded,
        label: 'View Profile',
        onTap: widget.onTap,
      ),
      VooProfileMenuItem(
        icon: Icons.settings_outlined,
        label: 'Settings',
        onTap: widget.onSettingsTap,
      ),
      VooProfileMenuItem(
        icon: Icons.logout_rounded,
        label: 'Sign Out',
        onTap: widget.onLogout,
        isDestructive: true,
      ),
    ];

    final items = widget.menuItems ?? defaultItems;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius.lg),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...items.map((item) => ListTile(
                  leading: Icon(
                    item.icon,
                    color: item.isDestructive
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    item.label,
                    style: TextStyle(
                      color: item.isDestructive
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    item.onTap?.call();
                  },
                )),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

/// User status options
enum VooUserStatus {
  online,
  away,
  busy,
  offline,
}

/// Menu item for profile dropdown
class VooProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  const VooProfileMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });
}
