import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/note.dart';

class ExportService {
  static final ExportService _instance = ExportService._internal();

  factory ExportService() {
    return _instance;
  }

  ExportService._internal();

  Future<String> exportToTxt(Note note) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final exportDir = Directory('${appDocDir.path}/exports');

      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = note.title.replaceAll(RegExp(r'[^\w\s]'), '');
      final file = File('${exportDir.path}/${fileName}_$timestamp.txt');

      final content = '''${note.title}
${note.createdAt}

${note.content}

---
Word Count: ${note.wordCount}
Character Count: ${note.characterCount}
Lines: ${note.lineCount}
''';

      await file.writeAsString(content);
      return file.path;
    } catch (e) {
      throw Exception('Failed to export to TXT: $e');
    }
  }

  Future<String> exportToPdf(Note note) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final exportDir = Directory('${appDocDir.path}/exports');

      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = note.title.replaceAll(RegExp(r'[^\w\s]'), '');
      final file = File('${exportDir.path}/${fileName}_$timestamp.pdf');

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  note.title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Created: ${note.createdAt.toString()}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'Modified: ${note.updatedAt.toString()}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  note.content,
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.Text(
                  'Statistics',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text('Words: ${note.wordCount}'),
                pw.Text('Characters: ${note.characterCount}'),
                pw.Text('Lines: ${note.lineCount}'),
              ],
            );
          },
        ),
      );

      await file.writeAsBytes(await pdf.save());
      return file.path;
    } catch (e) {
      throw Exception('Failed to export to PDF: $e');
    }
  }

  Future<String> exportToHtml(Note note) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final exportDir = Directory('${appDocDir.path}/exports');

      if (!await exportDir.exists()) {
        await exportDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = note.title.replaceAll(RegExp(r'[^\w\s]'), '');
      final file = File('${exportDir.path}/${fileName}_$timestamp.html');

      final html = '''<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${note.title}</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
      background-color: #f5f5f5;
    }
    .container {
      background-color: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    h1 {
      color: #333;
      border-bottom: 2px solid #007bff;
      padding-bottom: 10px;
    }
    .metadata {
      color: #666;
      font-size: 0.9em;
      margin-bottom: 20px;
    }
    .content {
      color: #333;
      white-space: pre-wrap;
      word-wrap: break-word;
    }
    .stats {
      margin-top: 20px;
      padding-top: 20px;
      border-top: 1px solid #ddd;
      color: #666;
      font-size: 0.9em;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>${note.title}</h1>
    <div class="metadata">
      <p>Created: ${note.createdAt}</p>
      <p>Modified: ${note.updatedAt}</p>
    </div>
    <div class="content">${note.content}</div>
    <div class="stats">
      <p><strong>Words:</strong> ${note.wordCount}</p>
      <p><strong>Characters:</strong> ${note.characterCount}</p>
      <p><strong>Lines:</strong> ${note.lineCount}</p>
    </div>
  </div>
</body>
</html>''';

      await file.writeAsString(html);
      return file.path;
    } catch (e) {
      throw Exception('Failed to export to HTML: $e');
    }
  }
}
