// ignore: file_names
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddTodo extends StatefulWidget {
  void Function({required String todoText}) addTodo;

  AddTodo({super.key, required this.addTodo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController todotext = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Add todo'),
        TextField(
          onSubmitted: (value) {
            if (todotext.text == '') {
            } else {
              widget.addTodo(todoText: todotext.text);
            }

            todotext.text = "";
          },
          autofocus: true,
          controller: todotext,
        ),
        ElevatedButton(
            onPressed: () {
              if (todotext.text == '') {
              } else {
                widget.addTodo(todoText: todotext.text);
              }

              todotext.text = "";
            },
            child: const Text('Add'))
      ],
    );
  }
}
