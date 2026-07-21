import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../services/index.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _pinController;
  bool _showPinInput = false;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return ListView(
            children: [
              // Theme section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'المظهر',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('الوضع الداكن'),
                value: settingsProvider.isDarkMode,
                onChanged: (value) {
                  settingsProvider.setDarkMode(value);
                },
              ),
              const Divider(),

              // Font size section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'حجم الخط',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Slider(
                  value: settingsProvider.fontSize,
                  min: 12,
                  max: 24,
                  divisions: 6,
                  label: settingsProvider.fontSize.toStringAsFixed(0),
                  onChanged: (value) {
                    settingsProvider.setFontSize(value);
                  },
                ),
              ),
              const Divider(),

              // Language section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'اللغة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text('العربية'),
                trailing: settingsProvider.language == 'ar'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  settingsProvider.setLanguage('ar');
                },
              ),
              ListTile(
                title: const Text('English'),
                trailing: settingsProvider.language == 'en'
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  settingsProvider.setLanguage('en');
                },
              ),
              const Divider(),

              // Security section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'الأمان',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('قفل التطبيق بـ PIN'),
                value: settingsProvider.isPinEnabled,
                onChanged: (value) async {
                  if (value) {
                    _showPinSetupDialog();
                  } else {
                    final encryptionService = EncryptionService();
                    await encryptionService.removePin();
                    settingsProvider.setPinEnabled(false);
                  }
                },
              ),
              const Divider(),

              // Backup section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'النسخ الاحتياطي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('إنشاء نسخة احتياطية'),
                onTap: _createBackup,
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('استعادة نسخة احتياطية'),
                onTap: _restoreBackup,
              ),
              const Divider(),

              // About section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'عن التطبيق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text('الإصدار'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: const Text('عن'),
                subtitle: const Text('MMH Notebook - تطبيق ملاحظات احترافي'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPinSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعيين PIN'),
        content: TextField(
          controller: _pinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            hintText: 'أدخل PIN من 4-6 أرقام',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pinController.clear();
            },
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_pinController.text.length >= 4) {
                final encryptionService = EncryptionService();
                await encryptionService.setPin(_pinController.text);
                context.read<SettingsProvider>().setPinEnabled(true);
                Navigator.pop(context);
                _pinController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تعيين PIN بنجاح')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يجب أن يكون PIN من 4-6 أرقام')),
                );
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _createBackup() async {
    try {
      final backupService = BackupService();
      final path = await backupService.createBackup();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم إنشاء نسخة احتياطية: $path')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  void _restoreBackup() async {
    try {
      final backupService = BackupService();
      final backups = await backupService.getBackupList();

      if (backups.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا توجد نسخ احتياطية')),
          );
        }
        return;
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('اختر نسخة احتياطية'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: backups.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(backupService.formatBackupDate(backups[index])),
                    onTap: () async {
                      Navigator.pop(context);
                      await backupService.restoreBackup(backups[index]);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم استعادة النسخة الاحتياطية')),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }
}
