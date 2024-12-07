import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/task_cubit.dart';
import '../model/task_model.dart';

class ToDoListScreen extends StatelessWidget {
  const ToDoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          return state.tasks.isEmpty
              ? const Center(child: Text('No tasks available'))
              : ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle:
                          Text('Date: ${task.date}, Status: ${task.status}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                _showTaskBottomSheet(context, task: task),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<TaskCubit>().deleteTask(task.id!);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
        } else if (state is TaskError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No tasks available'));
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskBottomSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show Bottom Sheet for Adding or Editing a Task
  _showTaskBottomSheet(BuildContext context, {Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final dateController = TextEditingController(text: task?.date ?? '');
    final statusController = TextEditingController(text: task?.status ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      task = Task(
                        id: task?.id,
                        title: titleController.text,
                        date: dateController.text,
                        status: statusController.text,
                      );
                      if (task?.id == null) {
                        context.read<TaskCubit>().addTask(task!);
                      } else {
                        context.read<TaskCubit>().updateTask(task!);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(task == null ? 'Add Task' : 'Update Task'),
                  ),
                  if (task != null)
                    ElevatedButton(
                      onPressed: () {
                        context.read<TaskCubit>().deleteTask(task!.id!);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete Task'),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
