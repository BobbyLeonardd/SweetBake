# 🚀 Deployment Guide - SweetBake

Panduan lengkap untuk deploy SweetBake ke production.

---

## 📋 Pre-Deployment Checklist

### Backend
- [ ] Database optimized & indexed
- [ ] API endpoints tested
- [ ] Error handling implemented
- [ ] Security measures in place
- [ ] Backup strategy ready
- [ ] SSL certificate obtained
- [ ] Domain name registered

### Frontend
- [ ] All features tested
- [ ] Performance optimized
- [ ] Error handling implemented
- [ ] API URLs configured for production
- [ ] App icons & splash screen ready
- [ ] App signing keys generated
- [ ] Privacy policy & terms prepared

---

## 🗄️ Backend Deployment

### Option 1: Shared Hosting (Recommended for Beginners)

#### Requirements
- PHP 7.4+
- MySQL 5.7+
- Apache with mod_rewrite
- cPanel or similar control panel

#### Steps

1. **Prepare Files**
   ```bash
   # Compress backend folder
   zip -r backend.zip backend/
   ```

2. **Upload to Server**
   - Login to cPanel
   - Go to File Manager
   - Navigate to `public_html/`
   - Upload `backend.zip`
   - Extract files

3. **Create Database**
   - Go to MySQL Databases in cPanel
   - Create new database: `sweetbake_db`
   - Create user: `sweetbake_user`
   - Grant all privileges
   - Note: database name, username, password

4. **Import Database**
   - Go to phpMyAdmin
   - Select `sweetbake_db`
   - Click Import
   - Choose `sweetbake.sql`
   - Click Go

5. **Configure Database Connection**
   
   Edit `backend/config/database.php`:
   ```php
   private $host = "localhost";
   private $db_name = "sweetbake_db";
   private $username = "sweetbake_user";
   private $password = "your_password_here";
   ```

6. **Test API**
   ```
   https://yourdomain.com/backend/api/products.php
   ```

7. **Enable HTTPS**
   - Install SSL certificate (Let's Encrypt free)
   - Force HTTPS in .htaccess:
   ```apache
   RewriteEngine On
   RewriteCond %{HTTPS} off
   RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
   ```

---

### Option 2: VPS (DigitalOcean, AWS, etc.)

#### Requirements
- Ubuntu 20.04+ or similar
- Root access
- Basic Linux knowledge

#### Steps

1. **Setup Server**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Install Apache
   sudo apt install apache2 -y
   
   # Install PHP
   sudo apt install php php-mysql php-mbstring php-xml -y
   
   # Install MySQL
   sudo apt install mysql-server -y
   ```

2. **Configure Apache**
   ```bash
   # Enable mod_rewrite
   sudo a2enmod rewrite
   
   # Create virtual host
   sudo nano /etc/apache2/sites-available/sweetbake.conf
   ```
   
   Add:
   ```apache
   <VirtualHost *:80>
       ServerName yourdomain.com
       DocumentRoot /var/www/sweetbake
       
       <Directory /var/www/sweetbake>
           AllowOverride All
           Require all granted
       </Directory>
       
       ErrorLog ${APACHE_LOG_DIR}/sweetbake_error.log
       CustomLog ${APACHE_LOG_DIR}/sweetbake_access.log combined
   </VirtualHost>
   ```
   
   ```bash
   # Enable site
   sudo a2ensite sweetbake.conf
   sudo systemctl reload apache2
   ```

3. **Upload Files**
   ```bash
   # Using SCP
   scp -r backend/ user@yourserver:/var/www/sweetbake/
   
   # Or using Git
   cd /var/www/sweetbake
   git clone your-repo-url .
   ```

4. **Setup Database**
   ```bash
   # Login to MySQL
   sudo mysql
   
   # Create database & user
   CREATE DATABASE sweetbake_db;
   CREATE USER 'sweetbake_user'@'localhost' IDENTIFIED BY 'strong_password';
   GRANT ALL PRIVILEGES ON sweetbake_db.* TO 'sweetbake_user'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;
   
   # Import database
   mysql -u sweetbake_user -p sweetbake_db < backend/database/sweetbake.sql
   ```

5. **Configure Permissions**
   ```bash
   sudo chown -R www-data:www-data /var/www/sweetbake
   sudo chmod -R 755 /var/www/sweetbake
   ```

6. **Install SSL (Let's Encrypt)**
   ```bash
   sudo apt install certbot python3-certbot-apache -y
   sudo certbot --apache -d yourdomain.com
   ```

7. **Setup Firewall**
   ```bash
   sudo ufw allow 'Apache Full'
   sudo ufw enable
   ```

---

## 📱 Frontend Deployment

### Android Deployment

#### 1. Prepare for Release

**Update API URL**

Edit `lib/config/api_config.dart`:
```dart
static const String baseUrl = 'https://yourdomain.com/backend/api';
```

**Update App Info**

Edit `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.yourcompany.sweetbake"
    minSdkVersion 21
    targetSdkVersion 33
    versionCode 1
    versionName "1.0.0"
}
```

**Update App Name**

Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="SweetBake"
    android:icon="@mipmap/ic_launcher">
```

#### 2. Generate Signing Key

```bash
keytool -genkey -v -keystore ~/sweetbake-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sweetbake
```

Save the password securely!

#### 3. Configure Signing

Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=sweetbake
storeFile=/path/to/sweetbake-key.jks
```

Edit `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### 4. Build APK

```bash
# Build APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### 5. Build App Bundle (for Play Store)

```bash
# Build App Bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

#### 6. Test APK

```bash
# Install on device
flutter install --release
```

---

### iOS Deployment

#### 1. Prepare for Release

**Update API URL** (same as Android)

**Update App Info**

Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleName</key>
<string>SweetBake</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
```

#### 2. Configure Xcode

```bash
# Open Xcode
open ios/Runner.xcworkspace
```

In Xcode:
1. Select Runner in project navigator
2. Go to Signing & Capabilities
3. Select your Team
4. Configure Bundle Identifier: `com.yourcompany.sweetbake`

#### 3. Build for Release

```bash
flutter build ios --release
```

#### 4. Archive & Upload

1. Open Xcode
2. Product → Archive
3. Wait for archive to complete
4. Click "Distribute App"
5. Follow App Store Connect wizard

---

## 🏪 App Store Submission

### Google Play Store

#### Requirements
- [ ] Google Play Developer account ($25 one-time)
- [ ] App Bundle (.aab file)
- [ ] App icon (512x512 PNG)
- [ ] Feature graphic (1024x500 PNG)
- [ ] Screenshots (at least 2)
- [ ] Privacy policy URL
- [ ] App description

#### Steps

1. **Create App in Play Console**
   - Go to play.google.com/console
   - Click "Create app"
   - Fill in app details

2. **Upload App Bundle**
   - Go to Production → Releases
   - Click "Create new release"
   - Upload .aab file
   - Fill in release notes

3. **Store Listing**
   - Add app description
   - Upload screenshots
   - Add app icon & feature graphic
   - Select category
   - Add privacy policy URL

4. **Content Rating**
   - Complete questionnaire
   - Get rating

5. **Pricing & Distribution**
   - Select countries
   - Set price (free/paid)

6. **Submit for Review**
   - Review all sections
   - Click "Submit for review"
   - Wait 1-3 days for approval

---

### Apple App Store

#### Requirements
- [ ] Apple Developer account ($99/year)
- [ ] IPA file
- [ ] App icon (1024x1024 PNG)
- [ ] Screenshots (various sizes)
- [ ] Privacy policy URL
- [ ] App description

#### Steps

1. **Create App in App Store Connect**
   - Go to appstoreconnect.apple.com
   - Click "My Apps" → "+"
   - Fill in app information

2. **Upload Build**
   - Use Xcode or Transporter app
   - Upload IPA file
   - Wait for processing

3. **App Information**
   - Add description
   - Upload screenshots
   - Add app icon
   - Select category
   - Add privacy policy URL

4. **Pricing & Availability**
   - Select countries
   - Set price

5. **Submit for Review**
   - Fill in review information
   - Click "Submit for Review"
   - Wait 1-2 days for review

---

## 🔒 Security Checklist

### Backend
- [ ] HTTPS enabled
- [ ] Database credentials secured
- [ ] SQL injection prevention (PDO)
- [ ] XSS prevention
- [ ] CSRF protection
- [ ] Rate limiting
- [ ] Input validation
- [ ] Error logging (not displaying)
- [ ] Regular backups
- [ ] Keep PHP/MySQL updated

### Frontend
- [ ] API keys secured
- [ ] No sensitive data in code
- [ ] HTTPS only
- [ ] Certificate pinning (optional)
- [ ] Obfuscation (optional)

---

## 📊 Monitoring & Maintenance

### Backend Monitoring

**Setup Error Logging**

Edit `backend/config/database.php`:
```php
// Log errors to file instead of displaying
ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', '/path/to/error.log');
```

**Monitor Server**
- CPU usage
- Memory usage
- Disk space
- Database size
- API response times

**Tools:**
- Google Analytics
- New Relic
- Sentry
- Custom logging

### Frontend Monitoring

**Firebase Crashlytics**
```yaml
# Add to pubspec.yaml
dependencies:
  firebase_crashlytics: ^3.4.0
```

**Google Analytics**
```yaml
dependencies:
  firebase_analytics: ^10.7.0
```

---

## 🔄 Update Strategy

### Backend Updates
1. Backup database
2. Test changes locally
3. Upload new files
4. Run database migrations if needed
5. Test API endpoints
6. Monitor for errors

### Frontend Updates
1. Update version in pubspec.yaml
2. Update version code/name in native configs
3. Test thoroughly
4. Build new release
5. Upload to stores
6. Submit for review

---

## 💾 Backup Strategy

### Database Backup

**Automated Daily Backup**
```bash
# Create backup script
nano /home/user/backup.sh
```

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
mysqldump -u sweetbake_user -p'password' sweetbake_db > /backups/sweetbake_$DATE.sql
# Keep only last 7 days
find /backups -name "sweetbake_*.sql" -mtime +7 -delete
```

```bash
# Make executable
chmod +x /home/user/backup.sh

# Add to crontab
crontab -e
# Add: 0 2 * * * /home/user/backup.sh
```

### Files Backup
- Backend code
- Uploaded images
- Configuration files

---

## 📈 Performance Optimization

### Backend
- Enable PHP OPcache
- Use database indexing
- Implement caching (Redis/Memcached)
- Optimize queries
- Use CDN for images

### Frontend
- Optimize images
- Enable code splitting
- Use lazy loading
- Minimize app size
- Cache API responses

---

## 🎉 Post-Deployment

### Checklist
- [ ] Test all features in production
- [ ] Monitor error logs
- [ ] Check analytics
- [ ] Gather user feedback
- [ ] Plan updates
- [ ] Market your app

---

**Deployment Complete! 🚀**

Your SweetBake app is now live and ready for users!
