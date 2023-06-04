
import 'package:hive/hive.dart';
import 'package:simple_not/models/note.dart';

class DatabaseService{
  final String boxName = 'notesBox';

  Future<void> addNote(Note note) async {
    final box = await Hive.openBox(boxName);
    await box.add(note);
  }

  Future<List<Note>> getAllNotes() async{
    final box = await Hive.openBox(boxName);
    return box.values.toList().cast<Note>();
  }

  Future<void> updateNote(int key,Note note) async{
    final box = await Hive.openBox(boxName);
    await box.put(key, note);
  }

  Future<void> deleteNote(Note note) async{
    final box = await Hive.openBox(boxName);
    await box.delete(note.key);
  }
}