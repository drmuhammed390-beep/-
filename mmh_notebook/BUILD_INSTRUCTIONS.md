# تعليمات البناء والتجميع - MMH Notebook

## المحتويات
1. [متطلبات البناء](#متطلبات-البناء)
2. [بناء تطبيق Windows](#بناء-تطبيق-windows)
3. [بناء تطبيق Android](#بناء-تطبيق-android)
4. [استكشاف الأخطاء](#استكشاف-الأخطاء)

---

## متطلبات البناء

### المتطلبات العامة
- Flutter SDK 3.12.2 أو أحدث
- Dart 3.12.2 أو أحدث
- Git

### متطلبات Windows
- Windows 10 أو أحدث
- Visual Studio 2022 أو أحدث (مع C++ build tools)
- أو MinGW

### متطلبات Android
- Android SDK
- Android NDK
- Java Development Kit (JDK) 11 أو أحدث
- Android Studio (اختياري)

---

## بناء تطبيق Windows

### الخطوة 1: تثبيت Flutter
```bash
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter --version
```

### الخطوة 2: تثبيت المكتبات
```bash
cd mmh_notebook
flutter pub get
```

### الخطوة 3: تشغيل التطبيق (اختياري للاختبار)
```bash
flutter run -d windows
```

### الخطوة 4: بناء ملف EXE
```bash
flutter build windows --release
```

### الملف الناتج
- المسار: `build/windows/runner/Release/mmh_notebook.exe`
- الحجم: حوالي 150-200 MB
- هذا الملف جاهز للتوزيع والتثبيت

### خيارات البناء المتقدمة
```bash
# بناء بدون تحسين
flutter build windows

# بناء مع معلومات تصحيح
flutter build windows --release --verbose

# بناء مع تحديد الهندسة المعمارية
flutter build windows --release --target-platform windows-x64
```

---

## بناء تطبيق Android

### الخطوة 1: تثبيت Android SDK
```bash
# على Linux/Mac
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# على Windows
set ANDROID_HOME=C:\Android\Sdk
set PATH=%PATH%;%ANDROID_HOME%\tools;%ANDROID_HOME%\tools\bin;%ANDROID_HOME%\platform-tools
```

### الخطوة 2: التحقق من الإعدادات
```bash
flutter doctor
```

### الخطوة 3: تثبيت المكتبات
```bash
cd mmh_notebook
flutter pub get
```

### الخطوة 4: تشغيل التطبيق (اختياري للاختبار)
```bash
flutter run -d android
```

### الخطوة 5: بناء ملف APK
```bash
flutter build apk --release
```

### الملف الناتج
- المسار: `build/app/outputs/flutter-apk/app-release.apk`
- الحجم: حوالي 50-80 MB
- هذا الملف جاهز للتثبيت على أجهزة Android

### خيارات البناء المتقدمة
```bash
# بناء APK بدون تحسين
flutter build apk

# بناء APK مع معلومات تصحيح
flutter build apk --release --verbose

# بناء AAB (Android App Bundle) للنشر على Play Store
flutter build appbundle --release
```

### توقيع التطبيق (اختياري)
```bash
# إنشاء مفتاح التوقيع
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# بناء APK موقع
flutter build apk --release --verbose
```

---

## استكشاف الأخطاء

### المشكلة: `flutter: command not found`
**الحل:**
```bash
# تأكد من أن Flutter موجود في PATH
export PATH="$PATH:/path/to/flutter/bin"
flutter --version
```

### المشكلة: `Android SDK not found`
**الحل:**
```bash
flutter doctor --android-licenses
# وافق على جميع الرخص
flutter doctor
```

### المشكلة: `Gradle build failed`
**الحل:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

### المشكلة: `Build failed: C++ compiler not found` (Windows)
**الحل:**
- ثبت Visual Studio Build Tools
- أو ثبت MinGW وأضفه إلى PATH

### المشكلة: `Out of memory` أثناء البناء
**الحل:**
```bash
# على Windows
set _JAVA_OPTIONS=-Xmx4g

# على Linux/Mac
export _JAVA_OPTIONS=-Xmx4g
```

---

## التحقق من البناء

### اختبار ملف Windows EXE
```bash
# تشغيل الملف مباشرة
./build/windows/runner/Release/mmh_notebook.exe

# أو من Windows Explorer
# انقر نقراً مزدوجاً على الملف
```

### اختبار ملف Android APK
```bash
# تثبيت على جهاز متصل
adb install build/app/outputs/flutter-apk/app-release.apk

# أو استخدام Android Studio
# File > Open > اختر ملف APK
```

---

## نصائح للبناء الناجح

1. **استخدم أحدث إصدار من Flutter**
   ```bash
   flutter upgrade
   ```

2. **امسح ملفات البناء القديمة**
   ```bash
   flutter clean
   rm -rf pubspec.lock
   flutter pub get
   ```

3. **استخدم وضع Release للبناء النهائي**
   ```bash
   flutter build windows --release
   flutter build apk --release
   ```

4. **اختبر التطبيق قبل البناء النهائي**
   ```bash
   flutter run -d windows
   flutter run -d android
   ```

5. **تحقق من الأخطاء**
   ```bash
   flutter analyze
   ```

---

## الملفات الناتجة

### Windows
- `build/windows/runner/Release/mmh_notebook.exe` - التطبيق الرئيسي
- `build/windows/runner/Release/` - ملفات الدعم والمكتبات

### Android
- `build/app/outputs/flutter-apk/app-release.apk` - التطبيق الرئيسي
- `build/app/outputs/flutter-apk/app-release-unsigned.apk` - بدون توقيع

---

## الدعم والمساعدة

للمساعدة في عملية البناء:
1. تحقق من [Flutter Documentation](https://flutter.dev/docs)
2. اطلع على [Android Build Documentation](https://developer.android.com/build)
3. تواصل مع فريق الدعم

---

تم التطوير بعناية لتوفير أفضل تجربة بناء.
