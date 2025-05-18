# Expense Tracker App

A Flutter-based mobile application for tracking personal expenses and managing budgets effectively.

## Features

- 📊 Track daily expenses and income
- 💰 Set and monitor category-wise budgets
- 🔔 Get notifications when budget limits are exceeded
- 📱 Clean and intuitive user interface
- 🎯 Categorize expenses (Food, Transport, Entertainment, etc.)
- 📅 Date-based expense tracking
- 💳 Support for multiple expense categories
- 🔄 Edit and delete existing expenses
- 📈 View expense history

## Categories

The app supports the following expense categories:

- Food
- Transport
- Entertainment
- Shopping
- Bills
- Health
- Education
- Other

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/anadecs/expense_tracker_flutter.git
cd expense_tracker
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Project Structure

```
lib/
├── models/         # Data models
├── providers/      # State management
├── screens/        # UI screens
├── utils/          # Utility functions
└── main.dart       # Entry point
```

## Dependencies

- `provider`: State management
- `flutter_slidable`: Swipe actions
- `intl`: Date and currency formatting
- `shared_preferences`: Local storage

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors who have helped shape this project
