#!/bin/bash

# Fix prefer_const_declarations
echo "Fixing prefer_const_declarations..."
find test -name "*.dart" -type f -exec sed -i '' 's/final \(oldValue = const\)/const \1/g' {} \;
find test -name "*.dart" -type f -exec sed -i '' 's/final \(newValue = const\)/const \1/g' {} \;
find test -name "*.dart" -type f -exec sed -i '' 's/final \(result = const\)/const \1/g' {} \;
find test -name "*.dart" -type f -exec sed -i '' 's/final \(oldTime = \)/const \1/g' {} \;
find test -name "*.dart" -type f -exec sed -i '' 's/final \(recentTime = \)/const \1/g' {} \;

# Fix use_named_constants - replace TextEditingValue(text: '') with TextEditingValue.empty
echo "Fixing use_named_constants..."
find test -name "*.dart" -type f -exec sed -i '' "s/const TextEditingValue(text: '')/TextEditingValue.empty/g" {} \;

# Remove redundant default arguments
echo "Fixing avoid_redundant_argument_values..."
find test -name "*.dart" -type f -exec sed -i '' 's/, isTyping: false//g' {} \;
find test -name "*.dart" -type f -exec sed -i '' 's/, isSubmitLoading: false//g' {} \;
find test -name "*.dart" -type f -exec sed -i '' 's/, reverseOrder: false//g' {} \;
find test -name "*.dart" -type f -exec sed -i '' 's/, isFullWidth: false//g' {} \;
find test -name "*.dart" -type f -exec sed -i '' 's/, allowNegative: true//g' {} \;
find test -name "*.dart" -type f -exec sed -i '' 's/, allowDecimals: true//g' {} \;

# Fix require_trailing_commas - Add trailing commas
echo "Fixing require_trailing_commas..."
# This is more complex to handle all cases correctly

echo "Lint fixes applied. Run 'flutter analyze' to verify."