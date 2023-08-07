import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/datas/modules.dart';
import 'package:todo_app/utils/cubits/task_control_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskControlCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Todo App'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> listTasks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocListener<TaskControlCubit, TaskControlState>(
        listener: (context, state) {},
        child: BlocBuilder<TaskControlCubit, TaskControlState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              listTasks = context.read<TaskControlCubit>().listTasks;
              return ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  context
                      .read<TaskControlCubit>()
                      .reorderTask(oldIndex, newIndex);
                },
                children: [
                  for (int i = 0; i < listTasks.length; i++)
                    ListTile(
                      leading: Checkbox(
                        value: listTasks[i].isCompleted,
                        onChanged: (value) {
                          context
                              .read<TaskControlCubit>()
                              .editTask(i, null, value, null);
                        },
                      ),
                      key: Key(i.toString()),
                      title: Text(listTasks[i].title),
                      subtitle: Text(listTasks[i].note),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editTask(context, listTasks[i], i);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<TaskControlCubit>().deleteTask(i);
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String newTaskTitle = '';
        String note = '';

        return BlocBuilder<TaskControlCubit, TaskControlState>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                    onChanged: (value) {
                      newTaskTitle = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Note',
                    ),
                    onChanged: (value) {
                      note = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final newTask = Task(title: newTaskTitle, note: note);
                    context.read<TaskControlCubit>().addTask(newTask);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editTask(BuildContext context, Task task, int index) {
    showDialog(
      context: context,
      builder: (context) {
        String editedTaskTitle = task.title;
        String editedTaskNote = task.note;

        return BlocBuilder<TaskControlCubit, TaskControlState>(
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                    controller: TextEditingController(text: task.title),
                    onChanged: (value) {
                      editedTaskTitle = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Note',
                    ),
                    controller: TextEditingController(text: task.note),
                    onChanged: (value) {
                      editedTaskNote = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<TaskControlCubit>()
                        .editTask(index, editedTaskTitle, null, editedTaskNote);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
