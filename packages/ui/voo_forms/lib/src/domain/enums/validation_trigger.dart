/// When to trigger validation
enum ValidationTrigger {
  onChange, // Validate on every change
  onBlur, // Validate when field loses focus
  onSubmit, // Validate only on form submit
  manual, // Manual validation only
}
