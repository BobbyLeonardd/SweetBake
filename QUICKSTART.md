# ⚡ Quick Start Guide - SweetBake

Get SweetBake up and running in 5 minutes!

---

## 🎯 Prerequisites Checklist

Before starting, make sure you have:
- [ ] Flutter SDK installed
- [ ] XAMPP or WAMP installed
- [ ] Android Studio or VS Code
- [ ] Android Emulator or iOS Simulator

---

## 🚀 5-Minute Setup

### Step 1: Database (2 minutes)

1. **Start XAMPP**
   - Open XAMPP Control Panel
   - Click **Start** on Apache
   - Click **Start** on MySQL

2. **Import Database**
   - Open browser: `http://localhost/phpmyadmin`
   - Click **Import** tab
   - Choose file: `backend/database/sweetbake.sql`
   - Click **Go**

✅ Done! Database ready.

---

### Step 2: Backend (1 minute)

1. **Copy Backend Files**
   ```
   Copy: sweetbake/backend/
   To: C:/xampp/htdocs/sweetbake/backend/
   ```

2. **Test API**
   - Open browser: `http://localhost/sweetbake/backend/api/products.php`
   - Should see JSON data

✅ Done! Backend ready.

---

### Step 3: Flutter (2 minutes)

1. **Install Dependencies**
   ```bash
   cd sweetbake
   flutter pub get
   ```

2. **Configure API URL**
   
   Edit `lib/config/api_config.dart`:
   
   **For Android Emulator:**
   ```dart
   static const String baseUrl = 'http://10.0.2.2/sweetbake/backend/api';
   ```
   
   **For iOS Simulator:**
   ```dart
   static const String baseUrl = 'http://localhost/sweetbake/backend/api';
   ```

3. **Run App**
   ```bash
   flutter run
   ```

✅ Done! App running.

---

## 🎉 You're Ready!

### Login as Admin
- **Email:** admin@sweetbake.com
- **Password:** password

### Or Register as Customer
- Click "Daftar" on login page
- Fill the form
- Start shopping!

---

## 🐛 Quick Troubleshooting

### Problem: "Connection refused"
**Solution:** 
- Make sure Apache & MySQL are running in XAMPP
- Test API in browser first

### Problem: "No data"
**Solution:**
- Check if database was imported correctly
- Go to phpMyAdmin and verify tables exist

### Problem: Flutter errors
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📱 What's Next?

### Explore Features
- ✅ Browse products
- ✅ Add to cart
- ✅ Checkout
- ✅ Track orders
- ✅ Manage products (Admin)

### Customize
- Change colors in `lib/config/theme_config.dart`
- Add your own products
- Modify UI as needed

### Deploy
- Build APK: `flutter build apk --release`
- Deploy backend to web server
- Configure production database

---

## 📚 Full Documentation

For detailed information, check:
- **README.md** - Overview & features
- **SETUP_GUIDE.md** - Detailed setup instructions
- **API_DOCUMENTATION.md** - API reference
- **PROJECT_STRUCTURE.md** - Code architecture

---

## 💡 Tips

1. **Use Hot Reload**
   - Press `r` in terminal for hot reload
   - Press `R` for hot restart

2. **Debug Mode**
   - Check terminal for errors
   - Use Flutter DevTools

3. **Test on Real Device**
   - Enable USB debugging
   - Connect phone
   - Run `flutter run`

---

## 🎯 Common Tasks

### Add New Product (Admin)
1. Login as admin
2. Go to "Kelola Produk"
3. Click "+" button
4. Fill form
5. Save

### Place Order (Customer)
1. Login as customer
2. Browse products
3. Add to cart
4. Go to cart
5. Checkout
6. Fill address
7. Select city
8. Place order

### Update Order Status (Admin)
1. Login as admin
2. Go to "Kelola Pesanan"
3. Click on order
4. Click edit icon
5. Select new status
6. Add description
7. Update

---

## 🔥 Pro Tips

### Development
- Use `flutter run --hot` for faster development
- Install Flutter extension in VS Code
- Use Flutter DevTools for debugging

### Backend
- Use Postman to test APIs
- Check Apache error logs for issues
- Keep database backed up

### Production
- Use environment variables for config
- Enable HTTPS/SSL
- Optimize images
- Add caching

---

## 📞 Need Help?

- Check **SETUP_GUIDE.md** for detailed instructions
- Read **API_DOCUMENTATION.md** for API details
- Open an issue on GitHub
- Check existing issues first

---

**Happy Coding! 🚀**

Start building your cake shop empire with SweetBake!
