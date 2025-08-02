# Contributing to Flutter Attendance Management System

Thank you for your interest in contributing to our Flutter Attendance Management System! We welcome contributions from everyone.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)
- [License](#license)

## 🤝 Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, sex characteristics, gender identity and expression, level of experience, education, socio-economic status, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

Examples of behavior that contributes to creating a positive environment include:

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Git
- Firebase account for testing
- Android Studio or VS Code

### First-time Setup

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/flutter-attendance-management.git`
3. Set up the upstream remote: `git remote add upstream https://github.com/ORIGINAL_OWNER/flutter-attendance-management.git`
4. Create a branch: `git checkout -b feature/your-feature-name`

## 🛠️ How to Contribute

### Types of Contributions

We welcome several types of contributions:

1. **🐛 Bug Reports** - Help us identify and fix bugs
2. **✨ Feature Requests** - Suggest new features or improvements
3. **📝 Documentation** - Improve or add documentation
4. **💻 Code Contributions** - Fix bugs or implement features
5. **🎨 Design Improvements** - UI/UX enhancements
6. **🧪 Testing** - Add or improve tests

### Before You Start

- Check if an issue already exists for your idea
- For major changes, open an issue first to discuss the approach
- Make sure you can test your changes thoroughly

## 💻 Development Setup

### 1. Environment Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/flutter-attendance-management.git
cd flutter-attendance-management

# Install dependencies
flutter pub get

# Verify Flutter installation
flutter doctor
```

### 2. Firebase Setup for Development

1. Create a test Firebase project
2. Enable Authentication and Firestore
3. Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. **Never commit these files to version control**

### 3. Running the App

```bash
# Run in debug mode
flutter run

# Run with specific device
flutter run -d <device_id>

# Run tests
flutter test
```

## 📏 Coding Standards

### Dart/Flutter Standards

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` before committing
- Maintain 80-character line limit where reasonable
- Use meaningful variable and function names

### Code Organization

```
lib/
├── app/
│   ├── data/           # Models and services
│   ├── modules/        # Feature modules
│   └── routes/         # App routing
├── shared/             # Shared components
└── utils/              # Utility functions
```

### Documentation Standards

- Add documentation comments for public APIs
- Use `///` for documentation comments
- Include examples in complex functions
- Update README.md for new features

### Example Code Style

````dart
/// Validates employee check-in location against office boundaries.
///
/// Returns `true` if the [userLocation] is within the allowed office area.
/// The [officeRadius] parameter defines the allowed distance in meters.
///
/// Example:
/// ```dart
/// bool isValid = validateLocation(
///   userLocation: LatLng(37.7749, -122.4194),
///   officeRadius: 100.0,
/// );
/// ```
bool validateLocation({
  required LatLng userLocation,
  required double officeRadius,
}) {
  // Implementation here
}
````

## 🔄 Pull Request Process

### 1. Before Creating a PR

- [ ] Ensure your branch is up to date with main
- [ ] Run `flutter test` - all tests must pass
- [ ] Run `dart format .` to format your code
- [ ] Update documentation if needed
- [ ] Add/update tests for new features

### 2. PR Requirements

- [ ] Clear, descriptive title
- [ ] Detailed description of changes
- [ ] Link to related issues
- [ ] Screenshots for UI changes
- [ ] Test results (if applicable)

### 3. PR Template

```markdown
## Description

Brief description of what this PR does.

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Related Issues

Fixes #(issue number)

## Screenshots (if applicable)

Add screenshots here

## Testing

- [ ] I have tested this change thoroughly
- [ ] All existing tests pass
- [ ] I have added tests for new functionality

## Checklist

- [ ] My code follows the project's coding standards
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have updated the documentation accordingly
```

### 4. Review Process

- All PRs require at least one review
- Address feedback promptly
- Keep PRs focused and reasonably sized
- Maintain a professional and respectful tone

## 🐛 Issue Guidelines

### Bug Reports

Use the bug report template and include:

- **Flutter version**: `flutter --version`
- **Device information**: OS, version, device model
- **Steps to reproduce**: Clear, numbered steps
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Screenshots/logs**: If applicable

### Feature Requests

- Clearly describe the feature
- Explain the use case and benefits
- Consider implementation complexity
- Suggest possible solutions

### Issue Labels

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Improvements or additions to documentation
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention is needed
- `priority: high/medium/low`: Issue priority

## 🧪 Testing Guidelines

### Test Types

1. **Unit Tests**: Test individual functions/methods
2. **Widget Tests**: Test Flutter widgets
3. **Integration Tests**: Test complete user flows

### Test Structure

```dart
void main() {
  group('AttendanceController', () {
    late AttendanceController controller;

    setUp(() {
      controller = AttendanceController();
    });

    test('should validate location correctly', () {
      // Test implementation
    });
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/controllers/attendance_controller_test.dart

# Run with coverage
flutter test --coverage
```

## 📦 Dependency Management

### Adding Dependencies

1. Check if the dependency is necessary
2. Prefer well-maintained packages
3. Consider package size and performance impact
4. Update `pubspec.yaml` with specific versions
5. Run `flutter pub deps` to check for conflicts

### Security Considerations

- Never commit sensitive information
- Use environment variables for API keys
- Follow Firebase security best practices
- Keep dependencies up to date

## 🚀 Release Process

### Version Numbering

We follow [Semantic Versioning](https://semver.org/):

- `MAJOR.MINOR.PATCH`
- Major: Breaking changes
- Minor: New features (backward compatible)
- Patch: Bug fixes (backward compatible)

### Release Checklist

- [ ] All tests pass
- [ ] Documentation updated
- [ ] Version number bumped
- [ ] Changelog updated
- [ ] Tagged release created

## 📞 Getting Help

### Communication Channels

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For general questions and ideas
- **Pull Request Comments**: For code-specific discussions

### Response Times

- We aim to respond to issues within 48 hours
- Pull requests are typically reviewed within a week
- Critical bugs are prioritized

## 🏆 Recognition

Contributors will be recognized in:

- README.md contributors section
- Release notes for significant contributions
- Special thanks in documentation

## 📝 License

By contributing, you agree that your contributions will be licensed under the MIT License that covers this project.
