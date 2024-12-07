import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/task_model.dart';
import '../network/database_helper.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final DatabaseHelper _dbHelper;

  TaskCubit(this._dbHelper) : super(TaskInitial());

  // Load tasks from the database
  void loadTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await _dbHelper.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    }
  }

  // Add a task
  void addTask(Task task) async {

    try {
      await _dbHelper.insertTask(task);
      loadTasks(); // Reload tasks after adding a new one
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
    }
  }

  // Edit a task
  void updateTask(Task task) async {
    try {
      await _dbHelper.updateTask(task);
      loadTasks(); // Reload tasks after updating
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  // Delete a task
  void deleteTask(int id) async {
    try {
      await _dbHelper.deleteTask(id);
      loadTasks(); // Reload tasks after deletion
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }
}
