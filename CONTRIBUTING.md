# 🤝 Contributing to SweetBake

Terima kasih atas minat Anda untuk berkontribusi pada SweetBake! Dokumen ini berisi panduan untuk berkontribusi pada project ini.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)

---

## 📜 Code of Conduct

### Our Pledge
- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the community

### Unacceptable Behavior
- Harassment or discrimination
- Trolling or insulting comments
- Publishing others' private information
- Other unprofessional conduct

---

## 🚀 How to Contribute

### Reporting Bugs

**Before submitting a bug report:**
- Check existing issues
- Update to the latest version
- Collect relevant information

**Bug Report Template:**
```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- Device: [e.g. iPhone 12, Samsung Galaxy S21]
- OS: [e.g. iOS 15, Android 12]
- App Version: [e.g. 1.0.0]
```

### Suggesting Features

**Feature Request Template:**
```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
A clear description of what you want to happen.

**Describe alternatives you've considered**
Any alternative solutions or features.

**Additional context**
Add any other context or screenshots.
```

### Contributing Code

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Test your changes**
5. **Commit your changes**
6. **Push to your fork**
7. **Open a Pull Request**

---

## 🛠️ Development Setup

### Prerequisites
- Flutter SDK 3.0+
- XAMPP/WAMP (Apache + MySQL + PHP)
- Git
- Code editor (VS Code recommended)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/sweetbake.git
   cd sweetbake
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup backend**
   - Copy `backend/` to `htdocs/sweetbake/backend/`
   - Import `backend/database/sweetbake.sql` to MySQL
   - Start Apache & MySQL

4. **Configure API**
   - Edit `lib/config/api_config.dart`
   - Set correct base URL

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 📝 Coding Standards

### Flutter/Dart

**File Naming**
- Use `snake_case` for file names
- Example: `product_card.dart`, `api_service.dart`

**Class Naming**
- Use `PascalCase` for class names
- Example: `ProductCard`, `ApiService`

**Variable Naming**
- Use `camelCase` for variables
- Example: `productList`, `isLoading`

**Code Style**
```dart
// Good
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Text(product.name),
      ),
    );
  }
}

// Bad
class productcard extends StatelessWidget {
  Product product;
  Function onTap;
  
  productcard(this.product, this.onTap);
  
  Widget build(context) {
    return Card(child: InkWell(onTap: onTap, child: Text(product.name)));
  }
}
```

**Best Practices**
- Use `const` constructors when possible
- Avoid using `print()` in production code
- Handle errors gracefully
- Add comments for complex logic
- Use meaningful variable names
- Keep functions small and focused

### PHP

**File Naming**
- Use `snake_case` for file names
- Example: `auth.php`, `products.php`

**Code Style**
```php
// Good
class Database {
    private $host = "localhost";
    private $dbName = "sweetbake";
    
    public function getConnection() {
        try {
            $conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->dbName,
                $this->username,
                $this->password
            );
            return $conn;
        } catch(PDOException $e) {
            echo "Connection error: " . $e->getMessage();
        }
    }
}

// Bad
class database {
  var $host="localhost";
  function getConnection(){
    $conn=new PDO("mysql:host=".$this->host,$this->username,$this->password);
    return $conn;
  }
}
```

**Best Practices**
- Use PDO prepared statements (prevent SQL injection)
- Validate and sanitize input
- Use proper error handling
- Add CORS headers
- Use meaningful variable names
- Comment complex logic

---

## 💬 Commit Guidelines

### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### Examples
```bash
# Good commits
feat(auth): add login functionality
fix(cart): resolve quantity update bug
docs(readme): update setup instructions
style(theme): improve color scheme
refactor(api): optimize product fetching
test(order): add order creation tests
chore(deps): update flutter dependencies

# Bad commits
update
fix bug
changes
wip
```

### Commit Best Practices
- Write clear, concise messages
- Use present tense ("add" not "added")
- Keep subject line under 50 characters
- Add body for complex changes
- Reference issues when applicable

---

## 🔄 Pull Request Process

### Before Submitting

1. **Update your fork**
   ```bash
   git fetch upstream
   git merge upstream/main
   ```

2. **Run tests**
   ```bash
   flutter test
   flutter analyze
   ```

3. **Format code**
   ```bash
   flutter format .
   ```

4. **Check for errors**
   ```bash
   flutter analyze --no-fatal-infos
   ```

### PR Template

```markdown
## Description
Brief description of changes.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested on Android
- [ ] Tested on iOS
- [ ] Added unit tests
- [ ] Added widget tests

## Screenshots
If applicable, add screenshots.

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed code
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] No new warnings
- [ ] Added tests
- [ ] All tests pass
```

### Review Process

1. **Automated checks** must pass
2. **Code review** by maintainers
3. **Testing** on multiple devices
4. **Approval** from at least one maintainer
5. **Merge** into main branch

### After Merge

- Delete your feature branch
- Update your fork
- Celebrate! 🎉

---

## 🎨 UI/UX Contributions

### Design Guidelines
- Follow Material Design principles
- Maintain consistent spacing
- Use theme colors
- Ensure accessibility
- Test on multiple screen sizes

### Adding New Screens
1. Create in appropriate folder (`views/admin/` or `views/customer/`)
2. Use existing widgets when possible
3. Follow naming conventions
4. Add navigation
5. Test thoroughly

---

## 📚 Documentation

### What to Document
- New features
- API changes
- Configuration changes
- Breaking changes
- Migration guides

### Documentation Style
- Clear and concise
- Include examples
- Add screenshots when helpful
- Keep up to date

---

## 🐛 Debugging Tips

### Flutter
```bash
# Run with verbose logging
flutter run -v

# Check for issues
flutter doctor

# Clean build
flutter clean
flutter pub get
```

### Backend
- Check Apache error logs
- Test API endpoints in browser
- Use Postman for API testing
- Check MySQL query logs

---

## 📞 Getting Help

### Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [PHP Documentation](https://www.php.net/docs.php)
- [MySQL Documentation](https://dev.mysql.com/doc/)

### Contact
- Open an issue for bugs
- Start a discussion for questions
- Join our community chat

---

## 🏆 Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to SweetBake! 🎉**
