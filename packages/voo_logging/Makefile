build_runner:
	dart run build_runner build --delete-conflicting-outputs

lint_fix:
	dart fix --apply && dart format --set-exit-if-changed .

# DevTools Extension Commands
prepare_devtools:
	dart run devtools_extensions build_and_copy --source=. --dest=extension/devtools

# Clean all build artifacts
clean_all:
	flutter clean
	cd example && flutter clean
	rm -rf devtools_extensions/

publish_package:
	dart pub publish --dry-run
	dart pub publish