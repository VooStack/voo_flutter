import 'dart:convert';

import 'package:flutter/material.dart';

/// User preferences for the DevTools extension
class UserPreferences {
  /// The preferred theme mode
  final ThemeMode themeMode;

  /// Width of the navigation panel
  final double navPanelWidth;

  /// Whether the navigation panel is collapsed
  final bool isNavCollapsed;

  /// Width of the details panel for each tab
  final Map<String, double> detailsPanelWidths;

  /// Whether auto-scroll is enabled for each tab
  final Map<String, bool> autoScrollEnabled;

  /// Last selected tab index
  final int lastSelectedTabIndex;

  /// Saved filter states per tab
  final Map<String, Map<String, dynamic>> filterStates;

  const UserPreferences({
    this.themeMode = ThemeMode.dark,
    this.navPanelWidth = 250.0,
    this.isNavCollapsed = false,
    this.detailsPanelWidths = const {},
    this.autoScrollEnabled = const {},
    this.lastSelectedTabIndex = 0,
    this.filterStates = const {},
  });

  /// Create a copy with updated values
  UserPreferences copyWith({
    ThemeMode? themeMode,
    double? navPanelWidth,
    bool? isNavCollapsed,
    Map<String, double>? detailsPanelWidths,
    Map<String, bool>? autoScrollEnabled,
    int? lastSelectedTabIndex,
    Map<String, Map<String, dynamic>>? filterStates,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      navPanelWidth: navPanelWidth ?? this.navPanelWidth,
      isNavCollapsed: isNavCollapsed ?? this.isNavCollapsed,
      detailsPanelWidths: detailsPanelWidths ?? this.detailsPanelWidths,
      autoScrollEnabled: autoScrollEnabled ?? this.autoScrollEnabled,
      lastSelectedTabIndex: lastSelectedTabIndex ?? this.lastSelectedTabIndex,
      filterStates: filterStates ?? this.filterStates,
    );
  }

  /// Get details panel width for a specific tab
  double getDetailsPanelWidth(String tabId, {double defaultWidth = 400.0}) {
    return detailsPanelWidths[tabId] ?? defaultWidth;
  }

  /// Get auto-scroll setting for a specific tab
  bool getAutoScroll(String tabId, {bool defaultValue = true}) {
    return autoScrollEnabled[tabId] ?? defaultValue;
  }

  /// Get filter state for a specific tab
  Map<String, dynamic>? getFilterState(String tabId) {
    return filterStates[tabId];
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'navPanelWidth': navPanelWidth,
      'isNavCollapsed': isNavCollapsed,
      'detailsPanelWidths': detailsPanelWidths,
      'autoScrollEnabled': autoScrollEnabled,
      'lastSelectedTabIndex': lastSelectedTabIndex,
      'filterStates': filterStates,
    };
  }

  /// Create from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 2],
      navPanelWidth: (json['navPanelWidth'] as num?)?.toDouble() ?? 250.0,
      isNavCollapsed: json['isNavCollapsed'] as bool? ?? false,
      detailsPanelWidths: (json['detailsPanelWidths'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          {},
      autoScrollEnabled:
          (json['autoScrollEnabled'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, v as bool),
              ) ??
              {},
      lastSelectedTabIndex: json['lastSelectedTabIndex'] as int? ?? 0,
      filterStates: (json['filterStates'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)),
          ) ??
          {},
    );
  }

  /// Encode to JSON string
  String encode() => jsonEncode(toJson());

  /// Decode from JSON string
  static UserPreferences decode(String source) {
    try {
      return UserPreferences.fromJson(
        jsonDecode(source) as Map<String, dynamic>,
      );
    } catch (_) {
      return const UserPreferences();
    }
  }
}
