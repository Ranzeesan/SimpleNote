import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_not/db/database_service.dart';
import 'package:simple_not/extensions/format_date.dart';
import 'package:simple_not/models/note.dart';
import 'package:simple_not/utils/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService dbService = DatabaseService();
  final GlobalKey<ScaffoldState> _sKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _sKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await GoRouter.of(context).pushNamed('add-note');
          setState(() {
            
          });
        },
        child: const Icon(Icons.note_add),
        ),
      appBar: AppBar(
        title: const Text("Simple Note App"),
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('notesBox').listenable(), 
        builder: (context, box, child) {
          if(box.values.isEmpty){
            return const Center(
              child: Text('Tidak Ada Catatan'),
            );
          }else{
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 5,);
              },
              itemCount: box.length,
              itemBuilder: (context, index) {
                Note currentNote = box.getAt(index);

                return Dismissible(
                  key: Key(currentNote.key.toString()),
                  onDismissed: (_) {
                    dbService.deleteNote(currentNote).then((value){
                      ScaffoldMessenger.of(_sKey.currentContext!)
                      .showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Catatan telah dihapus",
                          ),
                        ),
                      );
                    });
                  },
                  child: NoteCard(note: currentNote));
            },
          );
          }
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({
    super.key, 
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {
          GoRouter.of(context).pushNamed(
            AppRoutes.editNote,
            extra: note,
          );
        },
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          ),
        subtitle: Text(
          note.desc,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          ),
        trailing: Text(
          'Dibuat :\n${note.createdAt.formatDate()}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}