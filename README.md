# Invoice Manager - Flutter Mobile Application

A comprehensive Flutter mobile application for creating, managing, and exporting dynamic invoices with custom forms. Built with modern Flutter design principles and offline-first architecture.

## 🚀 Features

### Core Functionality
- **Dynamic Invoice Creation**: Create invoices with customizable fields at runtime
- **Custom Form Fields**: Support for 15+ field types including text, number, currency, date, dropdown, checkbox, and more
- **Drag & Drop Ordering**: Reorder fields with intuitive drag-and-drop interface
- **Offline Storage**: Complete offline functionality using Hive database
- **PDF Export**: Generate professional PDF invoices with branding
- **Multiple Sharing Options**: Share via WhatsApp, Email, Print, and local storage

### Field Types Supported
- 📝 Text & Multiline Text
- 🔢 Number & Currency
- 📧 Email & Phone
- 📅 Date, Time & DateTime
- 📋 Dropdown & Radio Buttons
- ☑️ Checkbox
- 📄 Text Area
- 📊 Percentage
- 🔗 URL

### UI/UX Features
- **Modern Design**: Clean, minimal interface with Material 3 design
- **Dark Mode Support**: Automatic theme switching
- **Smooth Animations**: Micro-interactions and page transitions
- **Responsive Layout**: Optimized for different screen sizes
- **Professional Typography**: Google Fonts (Inter) integration

### Data Management
- **Search & Filter**: Find invoices by title, client, or description
- **Sort Options**: Sort by date, amount, status, or client name
- **Status Management**: Track draft, sent, paid, overdue, and cancelled invoices
- **Statistics Dashboard**: View total invoices, revenue, and status breakdowns

## 🛠️ Technical Stack

### Core Technologies
- **Flutter**: 3.35.2+ (Dart 3.9.0+)
- **Hive**: Local database for offline storage
- **Provider**: State management
- **PDF**: Document generation
- **Google Fonts**: Typography

### Key Dependencies
```yaml
dependencies:
  flutter: sdk: flutter
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
  provider: ^6.1.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  pdf: ^3.10.7
  printing: ^5.12.0
  share_plus: ^7.2.2
  flutter_reorderable_list: ^1.3.0
  intl: ^0.19.0
  uuid: ^4.3.3
```

## 📱 Screenshots

### Dashboard
- Overview statistics
- Recent invoices
- Quick actions
- Dark/light mode toggle

### Invoice Creation
- Dynamic form builder
- Drag-and-drop field ordering
- Preset templates
- Real-time validation

### Invoice Management
- Search and filter
- Status management
- Bulk actions
- Export options

## 🏗️ Project Structure

```
lib/
├── models/                 # Data models
│   ├── invoice.dart
│   ├── dynamic_field.dart
│   ├── field_type.dart
│   └── app_settings.dart
├── services/               # Business logic
│   ├── database_service.dart
│   ├── pdf_service.dart
│   └── sharing_service.dart
├── providers/              # State management
│   ├── invoice_provider.dart
│   └── theme_provider.dart
├── screens/                # UI screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── create_invoice_screen.dart
│   ├── invoice_list_screen.dart
│   └── settings_screen.dart
├── widgets/                # Reusable components
│   ├── invoice_card.dart
│   ├── stats_card.dart
│   ├── quick_actions.dart
│   └── field_widgets/
│       ├── dynamic_field_widget.dart
│       └── reorderable_fields_list.dart
├── theme/                  # App theming
│   └── app_theme.dart
└── main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.35.2 or higher
- Dart 3.9.0 or higher
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd invoice
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   dart run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK**
```bash
flutter build apk --release
```

**iOS App**
```bash
flutter build ios --release
```

## 📊 Database Schema

### Invoice Model
- `id`: Unique identifier
- `title`: Invoice title
- `description`: Optional description
- `createdAt`: Creation timestamp
- `lastModified`: Last modification timestamp
- `fields`: List of dynamic fields
- `clientName`, `clientEmail`, `clientPhone`: Client information
- `companyName`, `companyAddress`, `companyPhone`, `companyEmail`: Company details
- `status`: Invoice status (draft, sent, paid, overdue, cancelled)
- `totalAmount`: Total invoice amount
- `currency`: Currency code
- `dueDate`: Payment due date
- `invoiceNumber`: Unique invoice number
- `notes`: Additional notes
- `signature`: Digital signature

### DynamicField Model
- `id`: Unique identifier
- `name`: Field display name
- `type`: Field type enum
- `value`: Field value
- `isRequired`: Required field flag
- `placeholder`: Input placeholder
- `hint`: Help text
- `order`: Display order
- `options`: Field-specific options
- `validation`: Validation rules
- `isVisible`: Visibility flag
- `defaultValue`: Default value
- `minValue`, `maxValue`: Numeric constraints
- `maxLength`: Text length limit
- `currency`: Currency code

## 🎨 Customization

### Adding New Field Types
1. Add new type to `FieldType` enum
2. Update `FieldTypeExtension` with display name and icon
3. Add widget implementation in `DynamicFieldWidget`
4. Update PDF generation in `PDFService`

### Theming
- Modify `AppTheme` class for color schemes
- Update typography in `AppTheme` text styles
- Customize gradients and decorations

### PDF Templates
- Edit `PDFService` for custom PDF layouts
- Modify header, footer, and content sections
- Add company branding elements

## 🔧 Configuration

### App Settings
- Company information
- Default currency
- Invoice numbering
- Theme preferences
- Backup settings

### Field Validation
- Required field validation
- Email format validation
- URL format validation
- Numeric range validation
- Custom validation rules

## 📈 Performance Optimizations

- **Lazy Loading**: Invoices loaded on demand
- **Image Caching**: Efficient image handling
- **Database Indexing**: Optimized Hive queries
- **Memory Management**: Proper disposal of controllers
- **Efficient Rendering**: Minimal rebuilds with Provider

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## 🚀 Deployment

### Android
1. Generate signed APK
2. Upload to Google Play Store
3. Configure app signing

### iOS
1. Build for iOS
2. Upload to App Store Connect
3. Submit for review

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Hive team for the excellent local database
- PDF package contributors
- Google Fonts for typography
- All open-source contributors

## 📞 Support

For support, email support@invoicemanager.com or create an issue in the repository.

---

**Built with ❤️ using Flutter**