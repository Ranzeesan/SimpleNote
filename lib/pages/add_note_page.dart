import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_not/db/database_service.dart';
import 'package:simple_not/models/note.dart';

 class AddNotePage extends StatefulWidget {
  const AddNotePage({
    super.key,
    this.note,
  });

  final Note? note;

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final DatabaseService dbService = DatabaseService();

  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState(){
    _titleController = TextEditingController();
    _descController = TextEditingController();

    if (widget.note != null){
      _titleController.text = widget.note!.title;
      _descController.text = widget.note!.desc;
    }

    super.initState();
  }

  @override
  void dispose(){
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Note tempNote = Note(
            title: _titleController.text, 
            desc: _descController.text, 
            createdAt: DateTime.now().toIso8601String(),
          );

          if (widget.note != null){
            await dbService.updateNote(
              widget.note!.key,
              tempNote,
              );
            GoRouter.of(context).pop();
          }else{
            await dbService.addNote(tempNote);
            // if (context.mounted) return;
            GoRouter.of(context).pop();
          }
          
        },
        label:const Text('Simpan'),
        icon: const Icon(Icons.save),
        ),
      appBar: AppBar(
        title: Text(
          widget.note != null? "Edit Note":"Add Note",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText : 'Masukan Judul',
                  hintStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    ),
                ),
                controller: _titleController,
              ),
              TextFormField(
                maxLines: 100,
                style: TextStyle(
                    fontSize: 14,
                    ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText : 'Masukan Deskripsi',
                  
                ),
                controller: _descController,
              ),
            ],
            ),
        ),
      ),
    );
  }
}