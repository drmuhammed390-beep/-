import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/index.dart';
import '../providers/index.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Note _currentNote;
  bool _isModified = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _currentNote = widget.note!;
      _titleController = TextEditingController(text: _currentNote.title);
      _contentController = TextEditingController(text: _currentNote.content);
    } else {
      _currentNote = Note(title: '', content: '');
      _titleController = TextEditingController();
      _contentController = TextEditingController();
    }

    _titleController.addListener(() => _setModified());
    _contentController.addListener(() => _setModified());
  }

  void _setModified() {
    if (!_isModified) {
      setState(() => _isModified = true);
    }
  }

  @override
  void dispose() {
    if (_isModified) {
      _saveNote();
    }
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      return;
    }

    final updatedNote = _currentNote.copyWith(
      title: title.isEmpty ? 'بدون عنوان' : title,
      content: content,
    );

    if (widget.note != null) {
      context.read<NotesProvider>().updateNote(updatedNote);
    } else {
      context.read<NotesProvider>().createNote(updatedNote.title, updatedNote.content);
    }

    setState(() => _isModified = false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (_isModified) {
          _saveNote();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('محرر الملاحظات'),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showMoreOptions,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Title field
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'العنوان',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Content field
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'ابدأ الكتابة...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: null,
                  minLines: 10,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                // Statistics
                _buildStatistics(),
                const SizedBox(height: 16),
                // Formatting toolbar
                _buildFormattingToolbar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    final stats = Note.calculateStats(_contentController.text);
    final readingTime = (stats['words']! / 200).ceil();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('كلمات', stats['words'].toString()),
          _buildStatItem('أحرف', stats['characters'].toString()),
          _buildStatItem('أسطر', stats['lines'].toString()),
          _buildStatItem('قراءة', '${readingTime}د'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFormattingToolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFormatButton(Icons.format_bold, 'B', () {
            _insertText('**نص غامق**');
          }),
          _buildFormatButton(Icons.format_italic, 'I', () {
            _insertText('*نص مائل*');
          }),
          _buildFormatButton(Icons.format_underlined, 'U', () {
            _insertText('__نص مسطر__');
          }),
          _buildFormatButton(Icons.strikethrough_s, 'S', () {
            _insertText('~~نص مشطوب~~');
          }),
          _buildFormatButton(Icons.format_list_bulleted, '•', () {
            _insertText('\n• عنصر\n• عنصر\n• عنصر');
          }),
          _buildFormatButton(Icons.format_list_numbered, '1', () {
            _insertText('\n1. عنصر\n2. عنصر\n3. عنصر');
          }),
          _buildFormatButton(Icons.checklist, '✓', () {
            _insertText('\n☐ مهمة\n☐ مهمة\n☐ مهمة');
          }),
          _buildFormatButton(Icons.today, '📅', () {
            final now = DateTime.now();
            _insertText('${now.year}-${now.month}-${now.day}');
          }),
        ],
      ),
    );
  }

  Widget _buildFormatButton(IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  void _insertText(String text) {
    final selection = _contentController.selection;
    final newText = _contentController.text.replaceRange(
      selection.start,
      selection.end,
      text,
    );
    _contentController.text = newText;
    _contentController.selection = TextSelection.fromPosition(
      TextPosition(offset: selection.start + text.length),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('إضافة للمفضلة'),
            onTap: () {
              context.read<NotesProvider>().toggleFavorite(_currentNote.id);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.push_pin_outlined),
            title: const Text('تثبيت'),
            onTap: () {
              context.read<NotesProvider>().togglePin(_currentNote.id);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text('أرشفة'),
            onTap: () {
              context.read<NotesProvider>().archiveNote(_currentNote.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('قفل'),
            onTap: () {
              context.read<NotesProvider>().lockNote(_currentNote.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('حذف'),
            onTap: () {
              context.read<NotesProvider>().deleteNote(_currentNote.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
