# Flutter Demo App

Simple Flutter app for QA testing. Shows users and their details.

## Install Flutter

Mac:
brew install flutter
flutter doctor


Windows/Linux: Download from flutter.dev

Fix issues that flutter doctor shows. Need Xcode for iOS and Android Studio for Android.

## Run This Project

First time:
cd flutter_demo_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs


Web:

flutter run -d chrome


iOS:
flutter run -d ios


Android:
flutter run -d android


## For QA Engineers

App fetches 10 users from an API. Tap a user to see details. Pull down or tap refresh button to reload.

Test keys for Appium:
- user_list
- user_card_1, user_card_2, etc
- user_name_1, user_email_1, etc
- refresh_button
- loading_indicator
- error_message
- user_detail_content
- name_value, email_value, phone_value

Basic test: launch app, wait for list, tap user, check details, go back. Test refresh and airplane mode for errors.

Use the keys instead of xpath. Configure your driver properly and find elements by key.

API is jsonplaceholder.typicode.com. Free testing API, always returns same 10 users.

## Structure


lib/
  main.dart
  core/di/
  data/models/
  data/services/
  presentation/screens/
  presentation/widgets/


## Dependencies

Three packages: dio, get_it, json_annotation

Run build_runner after pulling changes or if you modify the User model.