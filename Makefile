.PHONY: run-dev run-prod build-prod-ios build-prod-apk build-prod-aab setup-dev setup-prod release-ios-beta release-android-internal

## Development
run-dev: setup-dev
	flutter run --dart-define-from-file=env/dev.json

## Production
run-prod: setup-prod
	flutter run --dart-define-from-file=env/prod.json

## iOS builds
build-prod-ios: setup-prod
	flutter build ios --dart-define-from-file=env/prod.json

## Android builds
build-prod-apk: setup-prod
	flutter build apk --dart-define-from-file=env/prod.json

build-prod-aab: setup-prod
	flutter build appbundle --release --dart-define-from-file=env/prod.json

## Release (Fastlane)
release-ios-beta: setup-prod
	cd ios && bundle exec fastlane beta

release-android-internal: setup-prod
	cd android && bundle exec fastlane internal

## Setup helpers (generate iOS xcconfig)
setup-dev:
	@bash scripts/setup_env.sh env/dev.json

setup-prod:
	@bash scripts/setup_env.sh env/prod.json
