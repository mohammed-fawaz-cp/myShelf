# myShelf

**myShelf** is a premium, curated e-commerce experience built with Flutter. It focuses on timeless elegance, providing users with a high-end interface to browse, collect, and shop for masterpieces.

---

## ✨ Features

- **🛍️ Elegant Shopping Experience**: A dashboard and shop view featuring high-quality products from the FakeStoreAPI.
- **🔍 Smart Search & Filtering**: Real-time search and category-based filtering to find items quickly.
- **🛒 Dynamic Shopping Cart**: Full cart management including quantity updates and total price calculation.
- **❤️ Favorites System**: Save your most-loved items to your private collection.
- **🌙 Theme Switching**: Seamless transition between sophisticated Light and Dark modes.
- **📶 Offline Support**: Built-in caching mechanism to browse previously viewed products without an internet connection.
- **🔒 Authentication**: Secure-styled login flow with support for email/password and social login placeholders.
- **💎 Premium UI**: Glassmorphic elements, parallax imagery, and smooth animations powered by Google Fonts (Playfair Display & Inter).

---

## 🚀 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Riverpod 2.0](https://riverpod.dev/)
- **Networking**: [Dio](https://pub.dev/packages/dio)
- **Persistence**: [Shared Preferences](https://pub.dev/packages/shared_preferences)
- **Architecture**: Feature-driven Clean Architecture (Domain, Data, Presentation).
- **Styling**: Google Fonts, Glassmorphism, Custom Animations.

---

## 📂 Project Structure

The project follows a modular, feature-based architecture:

```text
lib/
├── core/               # Shared logic (Theming, Network Client, Error Handling)
├── features/
│   ├── auth/           # Login & User Management
│   ├── products/       # Dashboard, Shop View, Details, & Product Logic
│   ├── favorites/      # Saved Items persistence and UI
│   └── cart/           # Shopping Cart logic and screen
└── main.dart           # Application entry point & Provider initialization
```

---

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (^3.11.5)
- Android Studio / VS Code
- An emulator or physical device

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/myshelf.git
   ```

2. **Navigate to the directory**:
   ```bash
   cd myshelf
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## 📝 License

This project is for demonstration purposes. Feel free to use the code for your own learning and development!

---

*Curating the next generation of style. Built with ❤️ using Flutter.*
