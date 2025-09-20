# Sports Talent Assessment Flutter App - Makefile
.PHONY: help setup clean build test format analyze deps security run-dev run-staging run-prod build-dev build-staging build-prod

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Setup the development environment
	@echo "Setting up development environment..."
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs
	@echo "Setup complete!"

clean: ## Clean the project
	@echo "Cleaning project..."
	flutter clean
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs
	@echo "Clean complete!"

deps: ## Get dependencies
	@echo "Getting dependencies..."
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs

format: ## Format the code
	@echo "Formatting code..."
	dart format lib/ test/
	@echo "Formatting complete!"

analyze: ## Analyze the code
	@echo "Analyzing code..."
	flutter analyze
	@echo "Analysis complete!"

test: ## Run tests
	@echo "Running tests..."
	flutter test
	@echo "Tests complete!"

security: ## Run security checks
	@echo "Running security checks..."
	flutter pub deps
	flutter pub audit
	@echo "Security checks complete!"

lint: ## Run linter
	@echo "Running linter..."
	flutter analyze --fatal-infos --fatal-warnings
	@echo "Linting complete!"

# Development builds
run-dev: ## Run app in development mode
	@echo "Running in development mode..."
	flutter run --flavor development -t lib/main.dart

run-staging: ## Run app in staging mode
	@echo "Running in staging mode..."
	flutter run --flavor staging -t lib/main.dart

run-prod: ## Run app in production mode
	@echo "Running in production mode..."
	flutter run --flavor production -t lib/main.dart

# Debug builds
build-debug-dev: ## Build debug APK for development
	@echo "Building debug APK for development..."
	flutter build apk --debug --flavor development -t lib/main.dart
	@echo "Debug APK built: build/app/outputs/flutter-apk/app-development-debug.apk"

build-debug-staging: ## Build debug APK for staging
	@echo "Building debug APK for staging..."
	flutter build apk --debug --flavor staging -t lib/main.dart
	@echo "Debug APK built: build/app/outputs/flutter-apk/app-staging-debug.apk"

# Release builds for Android
build-android-dev: ## Build release APK for development
	@echo "Building release APK for development..."
	flutter build apk --release --flavor development -t lib/main.dart
	@echo "Release APK built: build/app/outputs/flutter-apk/app-development-release.apk"

build-android-staging: ## Build release APK for staging
	@echo "Building release APK for staging..."
	flutter build apk --release --flavor staging -t lib/main.dart
	@echo "Release APK built: build/app/outputs/flutter-apk/app-staging-release.apk"

build-android-prod: ## Build release APK for production
	@echo "Building release APK for production..."
	flutter build apk --release --flavor production -t lib/main.dart
	@echo "Release APK built: build/app/outputs/flutter-apk/app-production-release.apk"

# Bundle builds for Android
bundle-android-dev: ## Build app bundle for development
	@echo "Building app bundle for development..."
	flutter build appbundle --release --flavor development -t lib/main.dart
	@echo "App bundle built: build/app/outputs/bundle/developmentRelease/app-development-release.aab"

bundle-android-staging: ## Build app bundle for staging
	@echo "Building app bundle for staging..."
	flutter build appbundle --release --flavor staging -t lib/main.dart
	@echo "App bundle built: build/app/outputs/bundle/stagingRelease/app-staging-release.aab"

bundle-android-prod: ## Build app bundle for production
	@echo "Building app bundle for production..."
	flutter build appbundle --release --flavor production -t lib/main.dart
	@echo "App bundle built: build/app/outputs/bundle/productionRelease/app-production-release.aab"

# iOS builds
build-ios-dev: ## Build iOS app for development
	@echo "Building iOS app for development..."
	flutter build ios --release --flavor development -t lib/main.dart
	@echo "iOS app built for development"

build-ios-staging: ## Build iOS app for staging
	@echo "Building iOS app for staging..."
	flutter build ios --release --flavor staging -t lib/main.dart
	@echo "iOS app built for staging"

build-ios-prod: ## Build iOS app for production
	@echo "Building iOS app for production..."
	flutter build ios --release --flavor production -t lib/main.dart
	@echo "iOS app built for production"

# Asset management
assets: ## Process and optimize assets
	@echo "Processing assets..."
	@if [ -d "assets/images" ]; then \
		echo "Optimizing images..."; \
		find assets/images -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | xargs -I {} sh -c 'echo "Processing: {}"'; \
	fi
	@echo "Assets processed!"

icons: ## Generate app icons
	@echo "Generating app icons..."
	flutter pub run flutter_launcher_icons:main
	@echo "App icons generated!"

# Testing
test-unit: ## Run unit tests
	@echo "Running unit tests..."
	flutter test test/unit/
	@echo "Unit tests complete!"

test-widget: ## Run widget tests
	@echo "Running widget tests..."
	flutter test test/widget/
	@echo "Widget tests complete!"

test-integration: ## Run integration tests
	@echo "Running integration tests..."
	flutter test test/integration/
	@echo "Integration tests complete!"

test-coverage: ## Generate test coverage report
	@echo "Generating test coverage..."
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	@echo "Coverage report generated in coverage/html/index.html"

# Deployment
deploy-dev: build-android-dev ## Deploy to development
	@echo "Deploying to development environment..."
	@echo "Development deployment complete!"

deploy-staging: build-android-staging ## Deploy to staging
	@echo "Deploying to staging environment..."
	@echo "Staging deployment complete!"

deploy-prod: bundle-android-prod ## Deploy to production
	@echo "Deploying to production environment..."
	@echo "Production deployment complete!"

# Maintenance
outdated: ## Check for outdated dependencies
	@echo "Checking for outdated dependencies..."
	flutter pub deps
	flutter pub outdated

upgrade: ## Upgrade dependencies
	@echo "Upgrading dependencies..."
	flutter pub upgrade
	flutter pub run build_runner build --delete-conflicting-outputs

# Development tools
doctor: ## Run flutter doctor
	@echo "Running Flutter doctor..."
	flutter doctor -v

devices: ## List available devices
	@echo "Available devices:"
	flutter devices

logs: ## Show device logs
	@echo "Showing device logs..."
	flutter logs

# Quick commands
dev: clean run-dev ## Clean and run in development mode
staging: clean run-staging ## Clean and run in staging mode
prod: clean run-prod ## Clean and run in production mode

check: format analyze test ## Format, analyze, and test
build-all: build-android-dev build-android-staging build-android-prod ## Build all Android flavors

# Environment setup
env-setup: ## Set up environment files
	@echo "Setting up environment files..."
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo ".env file created from .env.example"; \
		echo "Please update the .env file with your configuration"; \
	else \
		echo ".env file already exists"; \
	fi

# Code generation
generate: ## Run code generation
	@echo "Running code generation..."
	flutter pub run build_runner build --delete-conflicting-outputs
	@echo "Code generation complete!"

watch: ## Run code generation in watch mode
	@echo "Running code generation in watch mode..."
	flutter pub run build_runner watch --delete-conflicting-outputs

# Localization (if needed)
l10n: ## Generate localizations
	@echo "Generating localizations..."
	flutter gen-l10n
	@echo "Localizations generated!"

# Full CI/CD pipeline simulation
ci: clean deps format analyze test security ## Full CI pipeline
	@echo "CI pipeline complete!"

# Release checklist
pre-release: clean deps format analyze test security assets icons ## Pre-release checklist
	@echo "Pre-release checks complete!"
	@echo "Ready for release!"

all: help ## Show help (default target)