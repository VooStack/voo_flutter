import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voo_forms/src/domain/entities/country_code.dart';
import 'package:voo_forms/src/presentation/config/utils/formatters/country_phone_formatter.dart';
import 'package:voo_forms/src/presentation/widgets/atoms/base/voo_field_base.dart';
import 'package:voo_forms/src/presentation/widgets/molecules/fields/voo_read_only_field.dart';
import 'package:voo_forms/voo_forms.dart';

/// Enhanced phone field with country code selection and formatting
/// 
/// Features:
/// - Country code dropdown when not specified
/// - Automatic phone number formatting based on country
/// - Flag emoji display
/// - International phone number validation
/// - Beautiful UI with proper Material 3 design
class VooPhoneField extends VooFieldBase<String> {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  
  /// Default country code (e.g., 'US', 'GB')
  /// If null, shows country selector dropdown
  final String? defaultCountryCode;
  
  /// Whether to show country dial code in the field
  final bool showDialCode;
  
  /// Whether to allow country selection (only when defaultCountryCode is null)
  final bool allowCountrySelection;
  
  /// Callback when country is changed
  final ValueChanged<CountryCode>? onCountryChanged;

  const VooPhoneField({
    super.key,
    required super.name,
    super.label,
    super.labelWidget,
    super.hint,
    super.helper,
    super.placeholder,
    super.initialValue,
    super.enabled,
    super.readOnly,
    super.validators,
    super.onChanged,
    super.actions,
    super.prefixIcon,
    super.suffixIcon,
    super.gridColumns,
    super.error,
    super.showError,
    super.layout,
    super.isHidden,
    super.minWidth,
    super.maxWidth,
    super.minHeight,
    super.maxHeight,
    this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.onSubmitted,
    this.autofocus = false,
    this.defaultCountryCode,
    this.showDialCode = false,
    this.allowCountrySelection = true,
    this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Return empty widget if hidden
    if (isHidden) return const SizedBox.shrink();

    final effectiveReadOnly = getEffectiveReadOnly(context);

    // If read-only, show formatted phone value
    if (effectiveReadOnly) {
      final String displayValue = initialValue ?? '';
      
      Widget readOnlyContent = VooReadOnlyField(
        value: displayValue,
        icon: const Icon(Icons.phone),
      );
      
      // Apply standard field building pattern
      readOnlyContent = buildWithHelper(context, readOnlyContent);
      readOnlyContent = buildWithError(context, readOnlyContent);
      readOnlyContent = buildWithLabel(context, readOnlyContent);
      readOnlyContent = buildWithActions(context, readOnlyContent);
      
      return buildFieldContainer(context, readOnlyContent);
    }

    // Use stateful widget for interactive phone field
    return _VooPhoneFieldStateful(
      key: ValueKey('voo_phone_field_$name'),
      field: this,
    );
  }

  @override
  VooPhoneField copyWith({
    String? initialValue,
    String? label,
    VooFieldLayout? layout,
    String? name,
    bool? readOnly,
  }) =>
      VooPhoneField(
        key: key,
        name: name ?? this.name,
        label: label ?? this.label,
        labelWidget: labelWidget,
        hint: hint,
        helper: helper,
        placeholder: placeholder,
        initialValue: initialValue ?? this.initialValue,
        enabled: enabled,
        readOnly: readOnly ?? this.readOnly,
        validators: validators,
        onChanged: onChanged,
        actions: actions,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        gridColumns: gridColumns,
        error: error,
        showError: showError,
        controller: controller,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
        defaultCountryCode: defaultCountryCode,
        showDialCode: showDialCode,
        allowCountrySelection: allowCountrySelection,
        onCountryChanged: onCountryChanged,
      );
}

/// Stateful widget to manage phone field state
class _VooPhoneFieldStateful extends StatefulWidget {
  final VooPhoneField field;

  const _VooPhoneFieldStateful({
    super.key,
    required this.field,
  });

  @override
  State<_VooPhoneFieldStateful> createState() => _VooPhoneFieldStatefulState();
}

class _VooPhoneFieldStatefulState extends State<_VooPhoneFieldStateful>
    with AutomaticKeepAliveClientMixin {
  TextEditingController? _effectiveController;
  FocusNode? _effectiveFocusNode;
  VooFormController? _formController;
  late CountryCode _selectedCountry;
  late CountryPhoneFormatter _phoneFormatter;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeCountry();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get the form controller from scope if available
    final formScope = VooFormScope.of(context);
    _formController = formScope?.controller;
    
    // Initialize controllers
    _initializeControllers();
  }
  
  void _initializeCountry() {
    // Set initial country based on defaultCountryCode or use US as default
    if (widget.field.defaultCountryCode != null) {
      _selectedCountry = CountryCode.findByIsoCode(widget.field.defaultCountryCode!) ??
          CountryCode.defaultCountry;
    } else {
      _selectedCountry = CountryCode.defaultCountry;
    }
    
    // Create formatter for the selected country
    _phoneFormatter = CountryPhoneFormatter(country: _selectedCountry);
  }
  
  void _initializeControllers() {
    // Use provided controller or get one from form controller if available
    if (widget.field.controller != null) {
      _effectiveController = widget.field.controller;
    } else if (_formController != null) {
      // Get the current value from the form controller if it exists
      final currentValue = _formController!.getValue(widget.field.name);
      final effectiveInitialValue = currentValue?.toString() ?? widget.field.initialValue;
      
      _effectiveController = _formController!.registerTextController(
        widget.field.name, 
        initialText: effectiveInitialValue,
      );
      
      // If we have an initial value but the controller doesn't have it yet, defer setting it
      if (effectiveInitialValue != null && currentValue == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _formController != null) {
            _formController!.setValue(widget.field.name, effectiveInitialValue, isUserInput: false);
          }
        });
      }
    } else if (_effectiveController == null) {
      // Create our own controller if we don't have one yet
      _effectiveController = TextEditingController(text: widget.field.initialValue);
    }
    
    // Use provided focus node, get from form controller, or create internal one
    if (widget.field.focusNode != null) {
      _effectiveFocusNode = widget.field.focusNode;
    } else if (_formController != null) {
      _effectiveFocusNode = _formController!.getFocusNode(widget.field.name);
    } else {
      _effectiveFocusNode = FocusNode();
    }
  }
  
  void _onCountryChanged(CountryCode? newCountry) {
    if (newCountry != null && newCountry != _selectedCountry) {
      setState(() {
        _selectedCountry = newCountry;
        _phoneFormatter = CountryPhoneFormatter(country: _selectedCountry);
        
        // Clear the text when country changes to avoid format conflicts
        _effectiveController?.clear();
      });
      
      // Notify callback if provided
      widget.field.onCountryChanged?.call(newCountry);
    }
  }
  
  Widget _buildCountrySelector() => DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: InkWell(
        onTap: widget.field.allowCountrySelection && 
               widget.field.defaultCountryCode == null &&
               widget.field.enabled != false
            ? _showCountryPicker
            : null,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedCountry.flag,
                style: const TextStyle(fontSize: 24),
              ),
              if (widget.field.showDialCode) ...[
                const SizedBox(width: 8),
                Text(
                  _selectedCountry.dialCode,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              if (widget.field.allowCountrySelection && 
                  widget.field.defaultCountryCode == null &&
                  widget.field.enabled != false) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: Theme.of(context).hintColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  
  void _showCountryPicker() {
    showModalBottomSheet<CountryCode>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) => Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Select Country',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(height: 1),
                // Country list
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: CountryCode.allCountries.length,
                    itemBuilder: (context, index) {
                      final country = CountryCode.allCountries[index];
                      final isSelected = country.isoCode == _selectedCountry.isoCode;
                      
                      return ListTile(
                        leading: Text(
                          country.flag,
                          style: const TextStyle(fontSize: 28),
                        ),
                        title: Text(country.name),
                        subtitle: Text(country.dialCode),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: Theme.of(context).primaryColor,
                              )
                            : null,
                        selected: isSelected,
                        onTap: () {
                          Navigator.pop(context);
                          _onCountryChanged(country);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
        ),
    );
  }

  @override
  void dispose() {
    // Only dispose the controller if we created it internally
    if (widget.field.controller == null && 
        _effectiveController != null && 
        _formController == null) {
      _effectiveController!.dispose();
    }
    if (widget.field.focusNode == null && 
        _effectiveFocusNode != null &&
        _formController == null) {
      _effectiveFocusNode!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Create wrapped onChanged that includes dial code if needed
    void handleChanged(String text) {
      String valueToStore = text;
      
      // If we should include dial code in the value, prepend it
      if (widget.field.showDialCode && text.isNotEmpty) {
        valueToStore = '${_selectedCountry.dialCode} $text';
      }
      
      // Update form controller if available
      if (_formController != null) {
        // Check if we should validate based on error display mode and current error state
        final hasError = _formController!.hasError(widget.field.name);
        final shouldValidate = hasError || 
            _formController!.errorDisplayMode == VooFormErrorDisplayMode.onTyping ||
            _formController!.validationMode == FormValidationMode.onChange;
        
        _formController!.setValue(widget.field.name, valueToStore, validate: shouldValidate);
      }
      
      // Call user's onChanged if provided
      widget.field.onChanged?.call(valueToStore);
    }
    
    // Build the phone input with country selector
    Widget phoneInput;
    
    if (_formController != null) {
      phoneInput = AnimatedBuilder(
        animation: _formController!,
        builder: (context, child) {
          // Get the current error from the form controller
          final error = _formController!.getError(widget.field.name);
          
          return TextFormField(
            controller: _effectiveController,
            focusNode: _effectiveFocusNode,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _phoneFormatter,
            ],
            onChanged: handleChanged,
            onEditingComplete: widget.field.onEditingComplete,
            onFieldSubmitted: widget.field.onSubmitted,
            enabled: widget.field.enabled,
            autofocus: widget.field.autofocus,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: widget.field.getInputDecoration(context).copyWith(
              prefixIcon: _buildCountrySelector(),
              prefixIconConstraints: const BoxConstraints(minWidth: 0),
              suffixIcon: widget.field.suffixIcon,
              errorText: widget.field.showError != false ? error : null,
              hintText: widget.field.placeholder ?? _selectedCountry.example,
            ),
          );
        },
      );
    } else {
      phoneInput = TextFormField(
        controller: _effectiveController,
        focusNode: _effectiveFocusNode,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          _phoneFormatter!,
        ],
        onChanged: handleChanged,
        onEditingComplete: widget.field.onEditingComplete,
        onFieldSubmitted: widget.field.onSubmitted,
        enabled: widget.field.enabled,
        autofocus: widget.field.autofocus,
        autocorrect: false,
        enableSuggestions: false,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: widget.field.getInputDecoration(context).copyWith(
          prefixIcon: _buildCountrySelector(),
          prefixIconConstraints: const BoxConstraints(minWidth: 0),
          suffixIcon: widget.field.suffixIcon,
          errorText: widget.field.showError != false ? widget.field.error : null,
          hintText: widget.field.placeholder ?? _selectedCountry.example,
        ),
      );
    }
    
    // Apply height constraints to the input widget
    final constrainedInput = widget.field.applyInputHeightConstraints(phoneInput);
    
    // Build with label, helper, and actions
    return widget.field.buildFieldContainer(
      context,
      widget.field.buildWithLabel(
        context,
        widget.field.buildWithHelper(
          context,
          widget.field.buildWithActions(
            context,
            constrainedInput,
          ),
        ),
      ),
    );
  }
}
