/// When to display form validation errors
enum VooFormErrorDisplayMode {
  /// Show errors as user types
  onTyping,
  
  /// Show errors only on form submission
  onSubmit,
  
  /// Never show errors automatically (developer handles manually)
  none,
}