# MMH Notebook

تطبيق ملاحظات احترافي وسريع وخفيف الوزن يعمل على Windows و Android بدون الحاجة للإنترنت.

## المميزات الرئيسية

### الملاحظات النصية
- إنشاء ملاحظات غير محدودة
- محرر نصوص متقدم مع تنسيق (Bold, Italic, Underline, Strikethrough)
- دعم كامل للعربية والإنجليزية مع RTL/LTR
- إحصائيات تفصيلية (كلمات، أحرف، أسطر، وقت القراءة)
- تثبيت الملاحظات المهمة
- إضافة للمفضلة
- أرشفة الملاحظات
- قفل الملاحظات

### إدارة الملاحظات
- تبويبات منظمة (الكل، الصور، التسجيلات، المفضلة، المؤرشفة، المغلقة)
- بحث احترافي مع تمييز النتائج
- فرز حسب التاريخ والأهمية
- حذف آمن مع تأكيد

### الأمان والخصوصية
- تشفير AES-256 لقاعدة البيانات
- قفل التطبيق بـ PIN
- قفل ملاحظات معينة
- عدم إرسال أي بيانات للإنترنت

### النسخ الاحتياطي والاستعادة
- إنشاء نسخ احتياطية محلية
- استعادة من نسخ احتياطية سابقة
- تصدير الملاحظات (PDF, HTML, TXT)

### المظهر والتخصيص
- وضع فاتح وداكن
- تخصيص حجم الخط
- دعم اللغات (العربية والإنجليزية)

## المتطلبات

### نظام التشغيل
- Windows 10 أو أحدث
- Android 8 أو أحدث

### متطلبات التطوير
- Flutter SDK 3.12.2 أو أحدث
- Dart 3.12.2 أو أحدث

## التثبيت والتشغيل

### 1. تثبيت Flutter
```bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter --version
```

### 2. استنساخ المشروع
```bash
cd mmh_notebook
```

### 3. تثبيت المكتبات
```bash
flutter pub get
```

### 4. تشغيل التطبيق

#### على Windows
```bash
flutter run -d windows
```

#### على Android
```bash
flutter run -d android
```

## البناء والتوزيع

### بناء ملف EXE (Windows)
```bash
flutter build windows --release
```
سيكون الملف في: `build/windows/runner/Release/mmh_notebook.exe`

### بناء ملف APK (Android)
```bash
flutter build apk --release
```
سيكون الملف في: `build/app/outputs/flutter-apk/app-release.apk`

## هيكل المشروع

```
mmh_notebook/
├── lib/
│   ├── main.dart              # نقطة الدخول الرئيسية
│   ├── models/                # نماذج البيانات
│   │   ├── note.dart
│   │   ├── image_item.dart
│   │   └── audio_recording.dart
│   ├── services/              # الخدمات
│   │   ├── database_service.dart
│   │   ├── encryption_service.dart
│   │   ├── backup_service.dart
│   │   └── export_service.dart
│   ├── providers/             # إدارة الحالة
│   │   ├── notes_provider.dart
│   │   └── settings_provider.dart
│   └── screens/               # الشاشات
│       ├── home_screen.dart
│       ├── note_editor_screen.dart
│       └── settings_screen.dart
├── assets/                    # الموارد
├── pubspec.yaml              # ملف المكتبات
└── README.md                 # هذا الملف
```

## المكتبات المستخدمة

- **sqflite**: قاعدة بيانات SQLite محلية
- **provider**: إدارة الحالة
- **encrypt**: التشفير AES-256
- **pdf**: تصدير PDF
- **image_picker**: اختيار الصور
- **file_picker**: اختيار الملفات
- **record**: تسجيل صوتي
- **audioplayers**: تشغيل الصوت
- **shared_preferences**: تخزين الإعدادات

## الميزات المخطط إضافتها

- [ ] دعم التسجيلات الصوتية الكاملة
- [ ] إدارة الصور والـ GIF
- [ ] الوسوم (Tags) والفئات
- [ ] سجل الإصدارات (Version History)
- [ ] التذكيرات والإشعارات
- [ ] المرفقات
- [ ] الروابط القابلة للنقر
- [ ] دعم قارئات الشاشة

## الترخيص

هذا المشروع مملوك لـ محمد معاذ.

## الدعم والمساعدة

للإبلاغ عن الأخطاء أو اقتراح ميزات جديدة، يرجى التواصل عبر البريد الإلكتروني.

---

تم التطوير بعناية لتوفير أفضل تجربة استخدام.
