# Flutter App Structure - School Management System

## 📐 Architecture Overview

### Architecture Pattern: **Clean Architecture + Feature-First**

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                      │
│  (UI, Widgets, BLoC/Cubit, Pages, State Management)        │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│                     Domain Layer                            │
│  (Entities, Use Cases, Repository Interfaces)              │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│                     Data Layer                              │
│  (Repository Impl, Data Sources, Models, API, Database)    │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Complete Folder Structure

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── app.dart                       # Main app widget
│   ├── app_router.dart                # Navigation configuration
│   └── bloc_observer.dart             # Global BLoC observer
│
├── core/                              # Shared/Core functionality
│   ├── constants/
│   │   ├── app_constants.dart         # App-wide constants
│   │   ├── api_constants.dart         # API endpoints
│   │   ├── storage_keys.dart          # Local storage keys
│   │   └── asset_constants.dart       # Asset paths
│   │
│   ├── config/
│   │   ├── app_config.dart            # Environment config
│   │   └── flavor_config.dart         # Flavor configuration
│   │
│   ├── theme/
│   │   ├── app_theme.dart             # Theme configuration
│   │   ├── app_colors.dart            # Color palette
│   │   ├── text_styles.dart           # Typography
│   │   └── app_dimensions.dart        # Spacing, sizes
│   │
│   ├── errors/
│   │   ├── exceptions.dart            # Custom exceptions
│   │   ├── failures.dart              # Failure classes
│   │   └── error_handler.dart         # Global error handler
│   │
│   ├── network/
│   │   ├── api_client.dart            # HTTP client (Dio)
│   │   ├── api_interceptor.dart       # Request/response interceptor
│   │   ├── network_info.dart          # Connectivity checker
│   │   └── api_response.dart          # Standardized API response
│   │
│   ├── database/
│   │   ├── database_helper.dart       # SQLite helper
│   │   ├── database_tables.dart       # Table definitions
│   │   ├── database_migrations.dart   # Migration logic
│   │   └── dao/                       # Data Access Objects
│   │       ├── base_dao.dart
│   │       ├── user_dao.dart
│   │       ├── course_dao.dart
│   │       └── ...
│   │
│   ├── sync/
│   │   ├── sync_manager.dart          # Sync orchestrator
│   │   ├── sync_queue.dart            # Offline operation queue
│   │   ├── conflict_resolver.dart     # Conflict resolution
│   │   └── sync_status.dart           # Sync state tracking
│   │
│   ├── utils/
│   │   ├── logger.dart                # Logging utility
│   │   ├── validators.dart            # Input validators
│   │   ├── date_utils.dart            # Date formatting
│   │   ├── file_utils.dart            # File operations
│   │   ├── encryption_utils.dart      # Encryption helpers
│   │   └── extensions/                # Dart extensions
│   │       ├── string_extensions.dart
│   │       ├── date_extensions.dart
│   │       └── context_extensions.dart
│   │
│   ├── widgets/                       # Reusable widgets
│   │   ├── buttons/
│   │   │   ├── primary_button.dart
│   │   │   ├── secondary_button.dart
│   │   │   └── icon_button.dart
│   │   ├── inputs/
│   │   │   ├── text_field.dart
│   │   │   ├── password_field.dart
│   │   │   ├── dropdown_field.dart
│   │   │   └── date_picker_field.dart
│   │   ├── cards/
│   │   │   ├── base_card.dart
│   │   │   ├── course_card.dart
│   │   │   └── assignment_card.dart
│   │   ├── dialogs/
│   │   │   ├── confirmation_dialog.dart
│   │   │   ├── error_dialog.dart
│   │   │   └── loading_dialog.dart
│   │   ├── loaders/
│   │   │   ├── circular_loader.dart
│   │   │   ├── shimmer_loader.dart
│   │   │   └── skeleton_loader.dart
│   │   ├── empty_states/
│   │   │   ├── empty_state.dart
│   │   │   └── error_state.dart
│   │   └── app_bar/
│   │       ├── custom_app_bar.dart
│   │       └── search_app_bar.dart
│   │
│   └── services/                      # Core services
│       ├── storage_service.dart       # Local storage (Hive/SharedPrefs)
│       ├── auth_service.dart          # Authentication
│       ├── notification_service.dart  # Push notifications
│       ├── file_service.dart          # File management
│       └── analytics_service.dart     # Analytics tracking
│
├── features/                          # Feature modules
│   │
│   ├── auth/                          # Authentication feature
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── login_response_model.dart
│   │   │   ├── datasources/
│   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       └── refresh_token_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   ├── forgot_password_page.dart
│   │       │   └── splash_page.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── social_login_buttons.dart
│   │
│   ├── onboarding/                    # Onboarding feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── home/                          # Home/Dashboard
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       │   └── home_page.dart
│   │       └── widgets/
│   │           ├── dashboard_card.dart
│   │           └── quick_actions.dart
│   │
│   ├── profile/                       # User Profile
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── courses/                       # Course Management
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── course_model.dart
│   │   │   │   └── enrollment_model.dart
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── course.dart
│   │   │   │   └── enrollment.dart
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   │       ├── get_courses_usecase.dart
│   │   │       ├── enroll_course_usecase.dart
│   │   │       └── get_course_details_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       │   ├── courses_list_page.dart
│   │       │   ├── course_details_page.dart
│   │       │   └── my_courses_page.dart
│   │       └── widgets/
│   │
│   ├── assignments/                   # Assignments
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       │   ├── assignments_list_page.dart
│   │       │   ├── assignment_details_page.dart
│   │       │   └── submit_assignment_page.dart
│   │       └── widgets/
│   │
│   ├── grades/                        # Grades & GPA
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── attendance/                    # Attendance Tracking
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── schedule/                      # Class Schedule
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── messages/                      # Messaging
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── notifications/                 # Notifications
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── documents/                     # Document Management
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── finance/                       # Financial Module
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── wallet_page.dart
│   │       │   ├── transactions_page.dart
│   │       │   └── payment_page.dart
│   │       └── widgets/
│   │
│   └── settings/                      # App Settings
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── di/                                # Dependency Injection
    ├── injection_container.dart       # Service locator setup
    └── injection_container.config.dart # Generated file

```

---

## 🎯 Key Architectural Decisions

### 1. **Clean Architecture Layers**

#### **Presentation Layer**
- **Responsibility**: UI, user interactions, state management
- **Components**: Pages, Widgets, BLoC/Cubit
- **Rules**: 
  - Can only depend on Domain layer
  - No direct access to Data layer
  - Uses UseCases to interact with business logic

#### **Domain Layer**
- **Responsibility**: Business logic, entities, contracts
- **Components**: Entities, UseCases, Repository interfaces
- **Rules**: 
  - Pure Dart (no Flutter dependencies)
  - No dependencies on other layers
  - Defines contracts (interfaces)

#### **Data Layer**
- **Responsibility**: Data management, API, database
- **Components**: Models, Repositories (impl), DataSources
- **Rules**: 
  - Implements Domain contracts
  - Handles data transformation
  - Manages local and remote data sources

---

### 2. **Feature-First Organization**

Each feature is **self-contained** with its own:
- Data layer (models, datasources, repositories)
- Domain layer (entities, usecases)
- Presentation layer (UI, state management)

**Benefits**:
- ✅ Easy to navigate
- ✅ Clear boundaries
- ✅ Scalable
- ✅ Team-friendly (multiple devs can work on different features)

---

### 3. **State Management: BLoC Pattern**

**Why BLoC?**
- ✅ Predictable state management
- ✅ Testable business logic
- ✅ Clear separation of concerns
- ✅ Excellent for complex apps
- ✅ Official Flutter recommendation

**Structure**:
```dart
feature/
  └── presentation/
      └── bloc/
          ├── feature_bloc.dart    # Business logic
          ├── feature_event.dart   # User actions
          └── feature_state.dart   # UI states
```

---

### 4. **Dependency Injection: GetIt + Injectable**

**Setup**:
```dart
// di/injection_container.dart
final sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register services
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  
  // Register repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  
  // Register use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
}
```

---

### 5. **Offline-First Strategy**

```
┌─────────────┐
│     UI      │
└──────┬──────┘
       │
┌──────▼──────────────────┐
│   Repository            │
│  (Single Source)        │
└──┬──────────────────┬───┘
   │                  │
┌──▼──────┐    ┌──────▼────┐
│ Local   │    │  Remote   │
│ DataSrc │◄───┤  DataSrc  │
└─────────┘    └───────────┘
     │              │
┌────▼────┐    ┌────▼────┐
│ SQLite  │    │   API   │
└─────────┘    └─────────┘
```

**Flow**:
1. UI requests data from Repository
2. Repository checks Local DataSource first
3. If data exists and fresh → return immediately
4. If stale or missing → fetch from Remote DataSource
5. Save to Local DataSource
6. Return to UI
7. Background sync updates stale data

---

### 6. **Sync Mechanism**

```dart
// core/sync/sync_manager.dart
class SyncManager {
  // Sync strategies
  - Manual sync (user-triggered)
  - Automatic sync (on app start, periodic)
  - Background sync (when online)
  - Conflict resolution (last-write-wins, manual)
  
  // Sync queue
  - Queue offline operations
  - Retry failed operations
  - Track sync status per table
}
```

---

## 📦 Required Dependencies

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Dependency Injection
  get_it: ^7.6.4
  injectable: ^2.3.2
  
  # Navigation
  go_router: ^13.0.0
  
  # Network
  dio: ^5.4.0
  connectivity_plus: ^5.0.2
  pretty_dio_logger: ^1.3.1
  
  # Local Storage
  sqflite: ^2.3.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # Code Generation
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  
  # UI/UX
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^3.0.0
  
  # Utilities
  intl: ^0.19.0
  path_provider: ^2.1.1
  permission_handler: ^11.1.0
  file_picker: ^6.1.1
  image_picker: ^1.0.5
  url_launcher: ^6.2.2
  
  # Firebase (optional)
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9
  firebase_analytics: ^10.8.0
  
  # Other
  uuid: ^4.2.2
  logger: ^2.0.2+1
  rxdart: ^0.27.7

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  injectable_generator: ^2.4.1
  
  # Testing
  mockito: ^5.4.4
  bloc_test: ^9.1.5
  
  # Linting
  flutter_lints: ^3.0.1
```

---

## 🔄 Data Flow Example

### Example: Login Flow

```
┌──────────┐
│   UI     │ LoginPage
└────┬─────┘
     │ 1. User taps login
     ▼
┌────────────┐
│ AuthBloc   │ Receives LoginEvent
└────┬───────┘
     │ 2. Calls UseCase
     ▼
┌──────────────┐
│ LoginUseCase │ Business logic
└────┬─────────┘
     │ 3. Calls Repository
     ▼
┌────────────────────┐
│ AuthRepository     │ Orchestrates data
└────┬───────────────┘
     │ 4. Calls Remote DataSource
     ▼
┌─────────────────────┐
│ AuthRemoteDataSrc   │ API call
└────┬────────────────┘
     │ 5. Returns UserModel
     ▼
┌────────────────────┐
│ AuthRepository     │ Saves to local
└────┬───────────────┘
     │ 6. Returns User entity
     ▼
┌──────────────┐
│ LoginUseCase │ Returns result
└────┬─────────┘
     │ 7. Emits state
     ▼
┌────────────┐
│ AuthBloc   │ Emits AuthSuccess
└────┬───────┘
     │ 8. UI updates
     ▼
┌──────────┐
│   UI     │ Navigate to Home
└──────────┘
```

---

## 🧪 Testing Strategy

```
test/
├── unit/                    # Unit tests
│   ├── domain/
│   │   └── usecases/
│   ├── data/
│   │   └── repositories/
│   └── utils/
│
├── widget/                  # Widget tests
│   └── features/
│       └── auth/
│           └── login_page_test.dart
│
└── integration/             # Integration tests
    └── auth_flow_test.dart
```

---

## 📝 Naming Conventions

### Files
- **Snake case**: `user_repository.dart`
- **Suffix by type**: 
  - Models: `user_model.dart`
  - Entities: `user.dart`
  - Pages: `login_page.dart`
  - Widgets: `custom_button.dart`
  - BLoC: `auth_bloc.dart`, `auth_event.dart`, `auth_state.dart`

### Classes
- **Pascal case**: `UserRepository`, `LoginPage`
- **Prefix by type**:
  - Abstract classes: `abstract class AuthRepository`
  - Implementations: `class AuthRepositoryImpl implements AuthRepository`

### Variables
- **Camel case**: `userName`, `isLoading`
- **Private**: `_privateVariable`

---

## 🚀 Implementation Order

### Phase 1: Core Setup (Week 1)
1. ✅ Set up folder structure
2. ✅ Configure dependencies
3. ✅ Set up dependency injection
4. ✅ Create base classes (BaseBloc, BaseRepository, etc.)
5. ✅ Set up theme and constants
6. ✅ Configure routing

### Phase 2: Authentication (Week 2)
1. ✅ Implement auth data layer
2. ✅ Implement auth domain layer
3. ✅ Implement auth presentation layer
4. ✅ Test authentication flow

### Phase 3: Core Features (Week 3-4)
1. ✅ Implement database layer
2. ✅ Implement sync mechanism
3. ✅ Implement home/dashboard
4. ✅ Implement profile

### Phase 4: Academic Features (Week 5-12)
1. ✅ Courses module
2. ✅ Assignments module
3. ✅ Grades module
4. ✅ Attendance module

---

## ✅ Advantages of This Structure

1. **Scalability**: Easy to add new features
2. **Maintainability**: Clear separation of concerns
3. **Testability**: Each layer can be tested independently
4. **Team Collaboration**: Multiple developers can work simultaneously
5. **Code Reusability**: Shared widgets and utilities
6. **Offline-First**: Built-in sync mechanism
7. **Clean Code**: Follows SOLID principles
8. **Industry Standard**: Recognized architecture pattern

---

## 🎯 Next Steps

1. **Review this structure**
2. **Approve or request changes**
3. **Start implementation**
4. **Set up core infrastructure**
5. **Implement authentication**
6. **Build feature by feature**

---

**Ready to proceed?** 🚀
