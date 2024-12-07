import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/views/home_view.dart';

import 'cubits/task_cubit.dart';
import 'network/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskCubit(DatabaseHelper.instance)..loadTasks(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter To-Do App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ToDoListScreen(),
      ),
    );
  }
}
