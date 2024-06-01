import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/addTodo.dart';
import 'package:todoapp/widgets/todoList.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> todolist = [];

  void addTodo({required String todoText}) {
    if (todolist.contains(todoText)) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Already exists 🤔',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text('This todo data already exist.'),
              actions: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text('close'))
              ],
            );
          });
      return;
    }

    setState(() {
      todolist.insert(0, todoText);
    });
    updateLocalData();
    Navigator.pop(context);
  }

  void updateLocalData() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('todolist', todolist);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    todolist = (prefs.getStringList('todolist') ?? []).toList();
    setState(() {});
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  void showAddToBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              child: AddTodo(addTodo: addTodo),
            ),
          );
        });
  }

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.blueGrey[900],
          // ignore: sort_child_properties_last
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: showAddToBottomSheet),
      drawer: Drawer(
          child: Column(
        children: [
          Container(
            color: Colors.blueGrey[900],
            height: 200,
            width: double.infinity,
            child: const Center(
              child: Text(
                'Todo App',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              launchUrl(Uri.parse('http://facebook.com'));
            },
            leading: const Icon(Icons.person),
            title: const Text('About Me'),
          ),
          ListTile(
            onTap: () {
              launchUrl(Uri.parse('mailto:someone@example.com'));
            },
            leading: const Icon(Icons.email),
            title: const Text('Contact Me'),
          ),
        ],
      )),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Todo App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [],
      ),
      body:
          TodoListBuilder(todoList: todolist, updateLocalData: updateLocalData),
    );
  }
}
