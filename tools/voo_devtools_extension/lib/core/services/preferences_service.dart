import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voo_devtools_extension/core/models/user_preferences.dart';
import 'package:web/web.dart' as web;

/// Service for managing user preferences persistence
class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  static const String _storageKey = 'voo_devtools_preferences';

  UserPreferences _preferences = const UserPreferences();
  final _preferencesController = StreamController<UserPreferences>.broadcast();

  /// Stream of preference changes
  Stream<UserPreferences> get preferencesStream => _preferencesController.stream;

  /// Current preferences
  UserPreferences get preferences => _preferences;

  /// Initialize the service and load saved preferences
  Future<void> initialize() async {
    await _loadPreferences();
  }

  /// Load preferences from storage
  Future<void> _loadPreferences() async {
    try {
      final stored = web.window.localStorage.getItem(_storageKey);
      if (stored != null && stored.isNotEmpty) {
        _preferences = UserPreferences.decode(stored);
        _preferencesController.add(_preferences);
      }
    } catch (e) {
      // If loading fails, use defaults
      _preferences = const UserPreferences();
    }
  }

  /// Save preferences to storage
  Future<void> _savePreferences() async {
    try {
      web.window.localStorage.setItem(_storageKey, _preferences.encode());
    } catch (e) {
      // Ignore storage errors
    }
  }

  /// Update preferences
  Future<void> updatePreferences(UserPreferences preferences) async {
    _preferences = preferences;
    _preferencesController.add(_preferences);
    await _savePreferences();
  }

  /// Update theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await updatePreferences(_preferences.copyWith(themeMode: themeMode));
  }

  /// Update nav panel width
  Future<void> setNavPanelWidth(double width) async {
    await updatePreferences(_preferences.copyWith(navPanelWidth: width));
  }

  /// Update nav collapsed state
  Future<void> setNavCollapsed(bool collapsed) async {
    await updatePreferences(_preferences.copyWith(isNavCollapsed: collapsed));
  }

  /// Update details panel width for a specific tab
  Future<void> setDetailsPanelWidth(String tabId, double width) async {
    final newWidths = Map<String, double>.from(_preferences.detailsPanelWidths);
    newWidths[tabId] = width;
    await updatePreferences(_preferences.copyWith(detailsPanelWidths: newWidths));
  }

  /// Update auto-scroll setting for a specific tab
  Future<void> setAutoScroll(String tabId, bool enabled) async {
    final newSettings = Map<String, bool>.from(_preferences.autoScrollEnabled);
    newSettings[tabId] = enabled;
    await updatePreferences(_preferences.copyWith(autoScrollEnabled: newSettings));
  }

  /// Update last selected tab
  Future<void> setLastSelectedTabIndex(int index) async {
    await updatePreferences(_preferences.copyWith(lastSelectedTabIndex: index));
  }

  /// Update filter state for a specific tab
  Future<void> setFilterState(String tabId, Map<String, dynamic> state) async {
    final newStates = Map<String, Map<String, dynamic>>.from(_preferences.filterStates);
    newStates[tabId] = state;
    await updatePreferences(_preferences.copyWith(filterStates: newStates));
  }

  /// Clear all preferences
  Future<void> clearPreferences() async {
    _preferences = const UserPreferences();
    _preferencesController.add(_preferences);
    try {
      web.window.localStorage.removeItem(_storageKey);
    } catch (e) {
      // Ignore
    }
  }

  void dispose() {
    _preferencesController.close();
  }
}
