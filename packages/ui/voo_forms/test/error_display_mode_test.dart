import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/src/domain/entities/error_display_mode.dart';

void main() {
  group('VooFormErrorDisplay Tests', () {
    group('shouldShowError', () {
      test('never mode never shows errors', () {
        const mode = VooFormErrorDisplay.never;
        
        final result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: true,
          hasBeenFocused: true,
          isCurrentlyFocused: false,
          hasBeenSubmitted: true,
          isTyping: true,
          lastTypeTime: DateTime.now(),
        );
        
        expect(result, isFalse);
      });
      
      test('onType mode shows errors when touched', () {
        const mode = VooFormErrorDisplay.onType;
        
        // Should not show when not touched
        var result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: false,
          hasBeenFocused: false,
          isCurrentlyFocused: false,
          hasBeenSubmitted: false,
          isTyping: false,
        );
        expect(result, isFalse);
        
        // Should show when touched
        result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: true,
          hasBeenFocused: false,
          isCurrentlyFocused: false,
          hasBeenSubmitted: false,
          isTyping: false,
        );
        expect(result, isTrue);
      });
      
      test('onBlur mode shows errors when field loses focus', () {
        const mode = VooFormErrorDisplay.onBlur;
        
        // Should not show while focused
        var result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: true,
          hasBeenFocused: true,
          isCurrentlyFocused: true,
          hasBeenSubmitted: false,
          isTyping: false,
        );
        expect(result, isFalse);
        
        // Should show after losing focus
        result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: true,
          hasBeenFocused: true,
          isCurrentlyFocused: false,
          hasBeenSubmitted: false,
          isTyping: false,
        );
        expect(result, isTrue);
      });
      
      test('onSubmit mode shows errors only after submission', () {
        const mode = VooFormErrorDisplay.onSubmit;
        
        // Should not show before submission
        var result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: true,
          hasBeenFocused: true,
          isCurrentlyFocused: false,
          hasBeenSubmitted: false,
          isTyping: false,
        );
        expect(result, isFalse);
        
        // Should show after submission
        result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: false,
          hasBeenFocused: false,
          isCurrentlyFocused: false,
          hasBeenSubmitted: true,
          isTyping: false,
        );
        expect(result, isTrue);
      });
      
      test('onInteraction mode shows errors after any interaction', () {
        const mode = VooFormErrorDisplay.onInteraction;
        
        // Should show when touched
        var result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: true,
          hasBeenFocused: false,
          isCurrentlyFocused: false,
          hasBeenSubmitted: false,
          isTyping: false,
        );
        expect(result, isTrue);
        
        // Should show when focused and lost focus
        result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: false,
          hasBeenFocused: true,
          isCurrentlyFocused: false,
          hasBeenSubmitted: false,
          isTyping: false,
        );
        expect(result, isTrue);
      });
      
      test('onTypeDebounced mode shows errors after delay', () {
        const mode = VooFormErrorDisplay.onTypeDebounced;
        
        // Should not show immediately after typing
        final recentTime = DateTime.now().subtract(const Duration(milliseconds: 500));
        var result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: true,
          hasBeenFocused: true,
          isCurrentlyFocused: true,
          hasBeenSubmitted: false,
          isTyping: true,
          lastTypeTime: recentTime,
        );
        expect(result, isFalse);
        
        // Should show after delay
        final oldTime = DateTime.now().subtract(const Duration(milliseconds: 1500));
        result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: true,
          hasBeenFocused: true,
          isCurrentlyFocused: true,
          hasBeenSubmitted: false,
          isTyping: false,
          lastTypeTime: oldTime,
        );
        expect(result, isTrue);
      });
      
      test('always mode always shows errors when present', () {
        const mode = VooFormErrorDisplay.always;
        
        // Should show even without interaction
        final result = mode.shouldShowError(
          hasError: true,
          hasBeenTouched: false,
          hasBeenFocused: false,
          isCurrentlyFocused: false,
          hasBeenSubmitted: false,
          isTyping: false,
        );
        expect(result, isTrue);
      });
      
      test('no mode shows error when hasError is false', () {
        for (final mode in VooFormErrorDisplay.values) {
          final result = mode.shouldShowError(
            hasError: false,
            hasBeenTouched: true,
            hasBeenFocused: true,
            isCurrentlyFocused: false,
            hasBeenSubmitted: true,
            isTyping: false,
            lastTypeTime: DateTime.now(),
          );
          expect(result, isFalse, 
            reason: '${mode.name} should not show error when hasError is false',);
        }
      });
    });
    
    group('autovalidateMode', () {
      test('returns correct AutovalidateMode for each error display mode', () {
        expect(VooFormErrorDisplay.never.autovalidateMode, 
          equals(AutovalidateMode.disabled),);
        
        expect(VooFormErrorDisplay.onType.autovalidateMode, 
          equals(AutovalidateMode.onUserInteraction),);
        
        expect(VooFormErrorDisplay.onBlur.autovalidateMode, 
          equals(AutovalidateMode.disabled),);
        
        expect(VooFormErrorDisplay.onSubmit.autovalidateMode, 
          equals(AutovalidateMode.disabled),);
        
        expect(VooFormErrorDisplay.onInteraction.autovalidateMode, 
          equals(AutovalidateMode.onUserInteraction),);
        
        expect(VooFormErrorDisplay.onTypeDebounced.autovalidateMode, 
          equals(AutovalidateMode.onUserInteraction),);
        
        expect(VooFormErrorDisplay.always.autovalidateMode, 
          equals(AutovalidateMode.always),);
      });
    });
    
    group('display properties', () {
      test('displayName returns correct names', () {
        expect(VooFormErrorDisplay.never.displayName, equals('Never'));
        expect(VooFormErrorDisplay.onType.displayName, equals('While Typing'));
        expect(VooFormErrorDisplay.onBlur.displayName, equals('On Focus Lost'));
        expect(VooFormErrorDisplay.onSubmit.displayName, equals('On Submit'));
        expect(VooFormErrorDisplay.onInteraction.displayName, equals('After Interaction'));
        expect(VooFormErrorDisplay.onTypeDebounced.displayName, equals('While Typing (Debounced)'));
        expect(VooFormErrorDisplay.always.displayName, equals('Always'));
      });
      
      test('description returns meaningful descriptions', () {
        for (final mode in VooFormErrorDisplay.values) {
          expect(mode.description, isNotEmpty, 
            reason: '${mode.name} should have a description',);
          expect(mode.description.length, greaterThan(10), 
            reason: '${mode.name} description should be meaningful',);
        }
      });
    });
  });
  
  group('VooFormErrorConfig Tests', () {
    test('default configuration has sensible defaults', () {
      const config = VooFormErrorConfig();
      
      expect(config.displayMode, equals(VooFormErrorDisplay.onBlur));
      expect(config.debounceDelay, equals(const Duration(milliseconds: 1000)));
      expect(config.showErrorIcon, isTrue);
      expect(config.showErrorBorder, isTrue);
      expect(config.shakeOnError, isFalse);
      expect(config.focusOnFirstError, isTrue);
    });
    
    test('copyWith creates new instance with updated values', () {
      const original = VooFormErrorConfig();
      final modified = original.copyWith(
        displayMode: VooFormErrorDisplay.onType,
        showErrorIcon: false,
      );
      
      expect(modified.displayMode, equals(VooFormErrorDisplay.onType));
      expect(modified.showErrorIcon, isFalse);
      // Other values should remain unchanged
      expect(modified.showErrorBorder, equals(original.showErrorBorder));
      expect(modified.debounceDelay, equals(original.debounceDelay));
    });
    
    test('predefined configurations have correct settings', () {
      // Immediate config
      expect(VooFormErrorConfig.immediate.displayMode, 
        equals(VooFormErrorDisplay.onType),);
      
      // Delayed config
      expect(VooFormErrorConfig.delayed.displayMode, 
        equals(VooFormErrorDisplay.onTypeDebounced),);
      
      // Gentle config
      expect(VooFormErrorConfig.gentle.displayMode, 
        equals(VooFormErrorDisplay.onBlur),);
      expect(VooFormErrorConfig.gentle.showErrorIcon, isFalse);
      expect(VooFormErrorConfig.gentle.shakeOnError, isFalse);
      
      // Strict config
      expect(VooFormErrorConfig.strict.displayMode, 
        equals(VooFormErrorDisplay.always),);
      expect(VooFormErrorConfig.strict.showErrorIcon, isTrue);
      expect(VooFormErrorConfig.strict.showErrorBorder, isTrue);
      expect(VooFormErrorConfig.strict.shakeOnError, isTrue);
      
      // Submit only config
      expect(VooFormErrorConfig.submitOnly.displayMode, 
        equals(VooFormErrorDisplay.onSubmit),);
      expect(VooFormErrorConfig.submitOnly.focusOnFirstError, isTrue);
    });
  });
}