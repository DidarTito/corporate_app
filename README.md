# Corporate Mobile App

## Description
Mobile application prototype for automating corporate HR services and internal communications. Built with Flutter for cross-platform compatibility.

## Release 1 Scope
- Authentication system with secure login flow
- User profile with dynamic data management
- Notifications center with organized display
- Help and contacts information
- Settings with language selection and theme switching

## Platforms
- iOS 16+
- Android 12+

## Features
- **Authentication**: Secure user login and session management
- **User Profile**: Dynamic profile with editable information including phone number, email, clothing size, and shoe size
- **Notifications**: Organized notification system with timestamp and sender information
- **Help & Contacts**: Quick access to support resources and contact information
- **Settings**: Multi-language support (Kazakh, Russian, English) and dark/light theme switching
- **Profile Editing**: Complete profile customization with real-time updates across all screens

## Technical Architecture
- **Framework**: Flutter 3.16.0+
- **State Management**: Provider pattern for efficient state synchronization
- **Data Flow**: Dynamic user data system with real-time synchronization
- **Theme System**: Custom color palette with consistent styling across all screens
- **Navigation**: Bottom navigation with indexed stack for smooth screen transitions

## Project Structure
```
lib/
├── models/
│   └── user_model.dart           # User data model with copyWith method
├── providers/
│   └── settings_provider.dart    # State management for settings and user data
├── screens/
│   ├── home_screen.dart          # Main dashboard with quick actions
│   ├── login_screen.dart         # User authentication
│   ├── profile_screen.dart       # Full profile display
│   ├── profile_edit_screen.dart  # Profile editing interface
│   ├── notifications_screen.dart # Notifications list
│   ├── contacts_screen.dart      # Contacts information
│   ├── help_screen.dart          # Help resources
│   └── settings_screen.dart      # App settings
├── widgets/
│   ├── bottom_nav_bar.dart       # Bottom navigation component
│   ├── home_app_bar.dart         # Custom app bar for home screen
│   └── profile_card.dart         # Reusable profile display card
├── data/
│   └── mock_data.dart            # Mock data including User class and notifications
├── utils/
│   └── constants.dart            # App constants and color definitions
└── main.dart                     # Application entry point
```

## Data Management
The application implements a sophisticated data synchronization system:
- **SettingsProvider**: Centralized state management handling language, theme, and user data
- **Dynamic Email System**: Login email stays synchronized with profile email across all screens
- **Real-time Updates**: User profile changes propagate instantly throughout the application
- **Data Persistence**: User preferences and profile data managed through provider state

## User Profile System
- **Editable Fields**: Phone number, email address, clothing size, and shoe size
- **Dynamic Updates**: Profile changes reflect immediately in both home and profile screens
- **Email Synchronization**: Login email automatically updates when profile email is changed
- **Validation**: Input validation for profile editing fields

## UX Implementation
- **Wireframes**: Designed in Miro with user flow consideration
- **Interactive Components**: Smooth animations and intuitive navigation patterns
- **Responsive Design**: Adapts to different screen sizes and orientations
- **Accessibility**: Support for text scaling and contrast requirements

## Getting Started
1. Ensure Flutter SDK version 3.16.0 or higher is installed
2. Clone the repository to your local machine
3. Run `flutter pub get` to install dependencies
4. Connect a physical device or start an emulator
5. Execute `flutter run` to launch the application

## Development Notes
- **Current Version**: Release 1 with enhanced dynamic data system
- **Code Quality**: Clean architecture with separation of concerns
- **Performance**: Optimized state management for smooth user experience
- **Maintainability**: Well-documented code with consistent naming conventions

## Future Releases
Release 2 and Release 3 will extend functionality with additional corporate services including document management, leave request systems, expense reporting, team collaboration tools, and integration with external corporate systems.

## Key Technical Solutions
- Implemented Provider-based state management for scalable architecture
- Developed dynamic user data system eliminating static data dependencies
- Created seamless email synchronization between authentication and profile systems
- Built modular widget architecture for maximum code reusability
- Established foundation for future feature expansion

## Version History
- **Release 1.0**: Initial implementation with basic features
- **Release 1.1**: Enhanced with dynamic user data system and theme improvements

## License
Proprietary software for corporate internal use.
