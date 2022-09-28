# Handling APIs in flutter.

    .
    lib
    ├── data
    │   ├── data_sourse
    │   │   ├── web_services.dart
    │   │   └── web_services.g.dart
    │   └── network
    │       ├── api_result.dart
    │       ├── api_result.freezed.dart
    │       ├── dio_factory.dart
    │       ├── network_exceptions.dart
    │       └── network_exceptions.freezed.dart
    ├── model
    │   ├── error_model.dart
    │   ├── error_model.g.dart
    │   ├── users.dart
    │   └── users.g.dart
    ├── presentation
    │   ├── cubit
    │   │   ├── users_cubit.dart
    │   │   ├── users_state.dart
    │   │   └── users_state.freezed.dart
    │   └── page
    │       ├── home_screen.dart
    │       ├── new_user.dart
    │       └── user_details.dart
    ├── repository
    │   └── repostory.dart
    ├── injection.dart
    └── main.dart
