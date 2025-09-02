import 'dart:async';

import 'package:flutter/material.dart';

/// Provider widget that manages side panel state
class VooSidePanelProvider extends StatefulWidget {
  final Widget child;
  
  const VooSidePanelProvider({
    super.key,
    required this.child,
  });
  
  @override
  State<VooSidePanelProvider> createState() => VooSidePanelProviderState();
  
  static VooSidePanelProviderState? of(BuildContext context) => context.findAncestorStateOfType<VooSidePanelProviderState>();
}

class VooSidePanelProviderState extends State<VooSidePanelProvider> {
  Widget? _sidePanel;
  String? _sidePanelTitle;
  double _sidePanelWidth = 400;
  void Function(BuildContext)? _onExit;
  final List<Completer<dynamic>> _sidePanelCompleter = [];
  
  Future<dynamic> openSidePanel({
    required Widget form,
    String? title,
    double width = 400,
    void Function(BuildContext)? onExit,
  }) async {
    final completer = Completer<dynamic>();
    _sidePanelCompleter.add(completer);
    
    // Defer the state update to the next frame to avoid mouse tracker conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _sidePanel = form;
          _sidePanelTitle = title;
          _sidePanelWidth = width;
          _onExit = onExit;
        });
      }
    });
    
    return completer.future;
  }
  
  void closeSidePanel([dynamic result]) {
    if (_sidePanelCompleter.isNotEmpty) {
      final completer = _sidePanelCompleter.removeLast();
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    }
    
    // Defer the state update to avoid mouse tracker conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _sidePanel = null;
          _sidePanelTitle = null;
          _onExit = null;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_sidePanel == null) {
      return widget.child;
    }
    
    return Row(
      children: [
        Expanded(
          child: widget.child,
        ),
        Container(
          width: _sidePanelWidth,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(-2, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_sidePanelTitle != null)
                _buildHeader(context),
              Expanded(
                child: _sidePanel ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _sidePanelTitle!,
            style: theme.textTheme.titleLarge,
          ),
          IconButton(
            onPressed: () {
              if (_onExit != null) {
                _onExit!(context);
              } else {
                closeSidePanel();
              }
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

