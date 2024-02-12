import 'package:flutter/material.dart';
import 'package:sqliteflutter/repository/notes_repo.dart';
import 'package:sqliteflutter/screens/add-note/add_not_screen.dart';
import 'package:sqliteflutter/screens/widgts/item_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Dairy"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => setState(() {}), icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: NotesRepository.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("Empty"),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(15),
              children: [
                for (var note in snapshot.data!)
                  ItemNote(
                    note: note,
                  )
              ],
            );
          }
          return SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const AddNoteScreen()));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
