import 'package:flutter/material.dart';

/// Custom route that displays content as a side panel on XL screens
/// Follows atomic design and KISS principle
class VooSidePanelRoute<T> extends PageRoute<T> {
  final Widget form;
  final String? title;
  final double width;
  final bool dismissible;

  VooSidePanelRoute({required this.form, this.title, this.width = 400, this.dismissible = true});

  @override
  Color? get barrierColor => Colors.black.withValues(alpha: 0.3);

  @override
  String? get barrierLabel => null;

  @override
  bool get barrierDismissible => dismissible;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Stack(
    children: [
      // Tap area for dismissing
      if (dismissible)
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
        ),
      // Side panel
      Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(-2, 0))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) _buildHeader(context),
                Expanded(child: form),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title!, style: theme.textTheme.titleLarge),
          IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
        ],
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;
}
