.PHONY: run-dev run-prod build-prod-ios build-prod-apk setup-dev setup-prod

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

## Setup helpers (generate iOS xcconfig)
setup-dev:
	@bash scripts/setup_env.sh env/dev.json

setup-prod:
	@bash scripts/setup_env.sh env/prod.json
