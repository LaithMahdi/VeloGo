<div align="center">
  <h1>🚴 VeloGo</h1>
  <p><strong>Smart Bike Rental System</strong></p>
  <p>A modern, feature-rich bike rental application built with Flutter and Supabase</p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)](https://dart.dev)
  [![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
  [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Running the App](#running-the-app)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Usage Guide](#-usage-guide)
- [Contributing](#-contributing)
- [License](#-license)
- [Contact](#-contact)

---

## 🎯 Overview

**VeloGo** is a comprehensive bike rental system that enables users to find, rent, and manage bike rentals through an intuitive mobile application. The app features real-time QR code scanning, duration-based pricing, live rental tracking with countdown timers, and seamless payment integration.

### Key Highlights

- 🔍 **QR Code Scanning**: Instant bike rental through QR code scanning
- ⏱️ **Real-Time Tracking**: Live countdown timers and rental status monitoring
- 💰 **Flexible Pricing**: Duration-based pricing from 30 minutes to 24 hours
- 📊 **Usage Statistics**: Track your rental history and spending
- 🗺️ **Station Finder**: Locate nearby bike stations on an interactive map
- 👤 **User Profiles**: Manage your account and view rental history

---

## ✨ Features

### Core Functionality

#### 🚲 Bike Management

- Browse available bikes with detailed information
- Real-time availability status
- Bike specifications and images
- Station-based bike locations

#### 📱 QR Code Scanner

- High-performance camera-based scanning
- Torch/flashlight support
- Front/back camera switching
- Automatic bike lookup and validation
- Error handling for invalid codes

#### ⏰ Rental System

- **Flexible Duration Options**:
  - 30 minutes - $2.50
  - 1 hour - $5.00
  - 2 hours - $10.00
  - 3 hours - $15.00
  - 4 hours - $20.00
  - 6 hours - $30.00
  - 12 hours - $60.00
  - 24 hours - $120.00
- Real-time countdown timer
- Elapsed time tracking
- Overtime notifications
- Automatic cost calculation
- Visual warnings for exceeded duration

#### 💳 Payment & Balance

- Integrated wallet system
- Balance validation before rental
- Automatic payment processing
- Transaction history
- Overtime charges

#### 📍 Station Locator

- Find nearby bike stations
- View available bikes per station
- Station details and operating hours
- Interactive map integration

#### 👤 User Management

- Secure authentication with Supabase
- Profile management
- Rental history
- Usage statistics
- Balance management

---

## 📸 Screenshots

> Add your app screenshots here

---

## 🛠️ Tech Stack

### Frontend

- **Framework**: Flutter 3.9.2
- **Language**: Dart 3.9.2
- **State Management**: Provider 6.1.5
- **Navigation**: GoRouter 17.0.0
- **UI Components**:
  - flutter_screenutil (Responsive design)
  - flutter_svg (Vector graphics)
  - flutter_spinkit (Loading animations)

### Backend

- **BaaS**: Supabase 2.10.3
- **Database**: PostgreSQL (via Supabase)
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage

### Key Packages

- `mobile_scanner` - QR code scanning
- `shared_preferences` - Local data persistence
- `flutter_dotenv` - Environment configuration
- `cupertino_icons` - iOS-style icons

---

## 🏗️ Architecture

VeloGo follows a clean, maintainable architecture pattern:

```
lib/
├── core/
│   ├── config.dart           # App configuration
│   ├── constant/             # Constants (routes, themes, images)
│   ├── functions/            # Utility functions
│   ├── service/              # Core services (Supabase, Storage)
│   └── utils/                # Helper utilities
├── data/
│   ├── model/                # Data models
│   └── service/              # Data services
├── providers/                # State management (Provider)
│   ├── auth_provider.dart
│   ├── bike_provider.dart
│   ├── rental_provider.dart
│   ├── profile_provider.dart
│   └── stats_provider.dart
├── views/                    # UI screens
│   ├── bike/                 # Bike-related screens
│   ├── home/                 # Home dashboard
│   ├── login/                # Authentication screens
│   ├── onboarding/           # App introduction
│   ├── profile/              # User profile
│   ├── rental/               # Rental management
│   ├── scan/                 # QR scanner
│   ├── splash/               # Splash screen
│   └── station/              # Station finder
├── shared/                   # Shared widgets and components
└── main.dart                 # App entry point
```

### Design Patterns

- **Provider Pattern**: State management across the app
- **Repository Pattern**: Data layer abstraction
- **Service Layer**: Business logic separation
- **Widget Composition**: Reusable UI components

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version 3.9.2 or higher
  ```bash
  flutter --version
  ```
- **Dart SDK**: Version 3.9.2 or higher
- **Android Studio** / **Xcode** (for mobile development)
- **Git**: For version control
- **Supabase Account**: For backend services

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/LaithMahdi/VeloGo
   cd velogo
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```

### Configuration

1. **Create a `.env` file** in the project root:

   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

2. **Configure Supabase**

   - Create a new Supabase project at [supabase.com](https://supabase.com)
   - Run the SQL scripts from `supabase_rentals_table.sql` in your Supabase SQL editor
   - Copy your project URL and anon key to the `.env` file

3. **Set up assets**
   - Place your logo images in `assets/images/logo/`
   - Place onboarding images in `assets/images/onboarding/`
   - Add custom fonts to `assets/fonts/` (Poppins font family)

### Running the App

#### Development Mode

**Android:**

```bash
flutter run
```

**iOS:**

```bash
flutter run
```

**Web:**

```bash
flutter run -d chrome
```

#### Production Build

**Android APK:**

```bash
flutter build apk --release
```

**Android App Bundle:**

```bash
flutter build appbundle --release
```

**iOS:**

```bash
flutter build ios --release
```

---

## 📁 Project Structure

```
VeloGo/
├── android/                  # Android platform files
├── ios/                      # iOS platform files
├── web/                      # Web platform files
├── lib/                      # Main application code
│   ├── core/                 # Core functionality
│   ├── data/                 # Data layer
│   ├── providers/            # State management
│   ├── shared/               # Shared components
│   └── views/                # UI screens
├── assets/                   # Images, fonts, and resources
│   ├── fonts/
│   └── images/
├── test/                     # Unit and widget tests
├── .env                      # Environment variables (not in repo)
├── pubspec.yaml              # Dependencies and project metadata
├── RENTAL_SYSTEM_GUIDE.md    # Detailed rental system documentation
└── README.md                 # This file
```

---

## 🗄️ Database Schema

### Core Tables

#### `profiles`

User account information and wallet balance

#### `bikes`

Bike inventory with specifications and availability status

#### `stations`

Physical locations where bikes can be picked up/returned

#### `rentals`

Active and completed rental records with pricing details

### Key Database Functions

- **`start_rental()`**: Initialize a new rental session
- **`complete_rental()`**: Finalize rental and process payment
- **`calculate_rental_cost()`**: Real-time cost calculation
- **`get_active_rental()`**: Retrieve current active rental

For detailed schema and SQL scripts, see [`supabase_rentals_table.sql`](supabase_rentals_table.sql).

---

## 📖 Usage Guide

### For Users

1. **Sign Up/Login**: Create an account or login with existing credentials
2. **Browse Bikes**: View available bikes at nearby stations
3. **Scan QR Code**: Use the scanner to scan a bike's QR code
4. **Select Duration**: Choose your rental duration (30 min - 24 hours)
5. **Confirm Rental**: Review pricing and confirm booking
6. **Track Rental**: Monitor remaining time and costs in real-time
7. **Return Bike**: Complete rental at any station and scan to return

### For Developers

See [`RENTAL_SYSTEM_GUIDE.md`](RENTAL_SYSTEM_GUIDE.md) for detailed implementation documentation including:

- QR code scanner setup
- Rental flow implementation
- Database functions and triggers
- Provider usage examples
- Common troubleshooting

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open a Pull Request**

### Coding Standards

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed
- Run `flutter analyze` before committing

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📧 Contact

**Project Maintainer**: Mahdi

**Project Link**: [https://github.com/yourusername/velogo](https://github.com/yourusername/velogo)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- Open source community for the excellent packages
- All contributors who have helped improve this project

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>⭐ Star this repo if you find it helpful!</p>
</div>
