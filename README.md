
````markdown
# 🧠 Flutter Chatbot Authentication App

A simple, clean, and well-structured Flutter application featuring login/signup authentication and a basic chatbot interface.

## ✨ Features

### 🔐 Authentication
- **Login Screen**
  - Email and Password fields with validation
  - Login button with state feedback
  - Navigation to Signup screen

- **Signup Screen**
  - Name, Email, Password fields with validation
  - Signup button
  - Navigation back to Login screen

- **Authentication Logic**
  - Dummy authentication (no backend)
  - Login state stored using `SharedPreferences`

### 💬 Chatbot
- Simple chat interface:
  - Input field for sending messages
  - List of messages (user + bot)
  - Hardcoded or logic-based dummy responses

---

## 🧱 Project Structure

```bash
lib/
├── bloc/                  # BLoC for authentication and chat
│   ├── auth_bloc.dart
│   ├── auth_event.dart
│   ├── auth_state.dart
│   ├── chat_bloc.dart
│   ├── chat_event.dart
│   └── chat_state.dart
├── screens/               # Screens for UI
│   ├── chat_screen.dart
│   ├── login_screen.dart
│   └── signup_screen.dart
├── theme/                 # Theme and styling
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   ├── app_theme.dart
│   └── ui_constants.dart
├── widgets/               # Reusable widgets
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   └── message_bubble.dart
└── main.dart              # App entry point
````

---

## 🧠 Tech Stack

* **Flutter SDK**
* **State Management:** BLoC
* **Routing:** Flutter Navigator
* **Local Storage:** SharedPreferences
* **Architecture:** Clean Architecture principles (Presentation, Domain, Data)

---

## 🧪 Validation

* Form validation for all fields (login/signup)
* Disabled buttons until valid inputs are entered

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK installed: [Install Flutter](https://docs.flutter.dev/get-started/install)
* An IDE such as VS Code or Android Studio

### Installation

```bash
git clone https://github.com/Kunalsalankar/uinihox.git
cd uinihox
flutter pub get
flutter run
```

---


## 📦 Dependencies

* `flutter_bloc`: State management
* `shared_preferences`: Local login state storage

---


---


