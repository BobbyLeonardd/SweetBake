# Checklist Sebelum Upload ke GitHub

## Persiapan

- [ ] Pastikan semua file sensitif sudah di-gitignore
- [ ] Hapus file build yang ga perlu (`build/`, `.dart_tool/`)
- [ ] Cek ga ada password atau API key hardcoded
- [ ] Test aplikasi sekali lagi (pastikan jalan)

## File yang Harus Ada

- [x] README.md (udah diperbaiki)
- [x] LICENSE (udah ada)
- [x] .gitignore (udah diperbaiki)
- [x] CONTRIBUTING.md (baru dibuat)
- [x] Issue templates (baru dibuat)
- [ ] Screenshot aplikasi (tambahin sendiri)

## Sebelum Push

1. **Buat repository baru di GitHub**
   - Nama: `sweetbake` atau `cake-shop-flutter`
   - Deskripsi: "Full-stack mobile app untuk manajemen toko kue dengan Flutter & PHP"
   - Public atau Private (terserah kamu)
   - Jangan centang "Initialize with README" (karena udah ada)

2. **Inisialisasi Git (kalo belum)**
```bash
git init
git add .
git commit -m "Initial commit: SweetBake - Cake Shop Management System"
```

3. **Connect ke GitHub**
```bash
git remote add origin https://github.com/username/sweetbake.git
git branch -M main
git push -u origin main
```

## Setelah Upload

- [ ] Tambahin screenshot di README
- [ ] Buat release tag (v1.0.0)
- [ ] Tambahin topics/tags di GitHub:
  - `flutter`
  - `php`
  - `mysql`
  - `e-commerce`
  - `mobile-app`
  - `cake-shop`
  - `portfolio`

## Tips Portfolio

1. **Tambahin screenshot yang menarik**
   - Screenshot admin dashboard
   - Screenshot customer app
   - Screenshot fitur bundling
   - Bisa pake tool kayak [Screely](https://screely.com/) buat bikin screenshot lebih keren

2. **Buat demo video (opsional)**
   - Record demo aplikasi
   - Upload ke YouTube
   - Tambahin link di README

3. **Tulis blog post (opsional)**
   - Jelasin proses development
   - Challenges yang dihadapi
   - Lessons learned
   - Link ke GitHub repo

4. **Share di social media**
   - LinkedIn (bagus buat portfolio)
   - Twitter/X
   - Dev.to
   - Reddit (r/FlutterDev)

## Hal yang Perlu Diperhatiin

### Jangan Upload:
- ❌ File `.env` dengan password asli
- ❌ API keys atau secrets
- ❌ File build (`build/`, `*.apk`, `*.ipa`)
- ❌ Dependencies (`node_modules/`, `vendor/`)
- ❌ IDE config yang personal (`.vscode/`, `.idea/`)

### Boleh Upload:
- ✅ Source code
- ✅ Database schema (`.sql`)
- ✅ Config template (`database.php` dengan password kosong)
- ✅ Dokumentasi
- ✅ Screenshot
- ✅ LICENSE

## Maintenance

Setelah upload, jangan lupa:
- Respond ke issues dan pull requests
- Update README kalo ada perubahan
- Tambahin CHANGELOG.md kalo ada update besar
- Keep dependencies up to date

---

**Good luck dengan portfolio kamu! 🚀**
