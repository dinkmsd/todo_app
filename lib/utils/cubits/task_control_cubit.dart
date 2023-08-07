import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/datas/modules.dart';

part 'task_control_state.dart';

class TaskControlCubit extends Cubit<TaskControlState> {
  final List<Task> listTasks = [];
  TaskControlCubit() : super(TaskControlInitial()) {
    attempLoadingTask();
  }

  void attempLoadingTask() async {
    emit(TaskLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final taskString = pref.getStringList('tasks');
      if (taskString != null) {
        for (var item in taskString) {
          final json = jsonDecode(item);
          listTasks.add(Task.fromJson(json));
        }
      }
      emit(TaskLoadedSuccess(listTasks: listTasks));
    } catch (exp) {
      emit(TaskLoadedFail(exp: exp as Exception));
    }
  }

  void loadTask() async {
    emit(TaskLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final taskString = pref.getStringList('tasks');
      if (taskString != null) {
        for (var item in taskString) {
          final json = jsonDecode(item);
          listTasks.add(Task.fromJson(json));
        }
      }
      emit(TaskLoadedSuccess(listTasks: listTasks));
    } catch (exp) {
      emit(TaskLoadedFail(exp: exp as Exception));
    }
  }

  void refreshTask() async {}

  void saveTask() async {
    emit(TaskLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final List<String> taskStrings =
          listTasks.map((task) => jsonEncode(task.toJson())).toList();
      await pref.setStringList('tasks', taskStrings);
      emit(TaskLoadedSuccess(listTasks: listTasks));
    } catch (exp) {
      emit(TaskLoadedFail(exp: exp as Exception));
    }
  }

  void addTask(Task task) async {
    listTasks.add(task);
    saveTask();
  }

  void editTask(
      int index, String? title, bool? isCompleted, String? note) async {
    listTasks[index].title = title ?? listTasks[index].title;
    listTasks[index].isCompleted = isCompleted ?? listTasks[index].isCompleted;
    listTasks[index].note = note ?? listTasks[index].note;
    saveTask();
  }

  void deleteTask(int index) async {
    listTasks.removeAt(index);
    saveTask();
  }

  void reorderTask(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Task task = listTasks.removeAt(oldIndex);
    listTasks.insert(newIndex, task);
    saveTask();
  }
}
