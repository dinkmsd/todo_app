part of 'task_control_cubit.dart';

@immutable
abstract class TaskControlState {}

class TaskControlInitial extends TaskControlState {}

class TaskLoading extends TaskControlState {}

class TaskLoadedSuccess extends TaskControlState {
  final List<Task> listTasks;
  TaskLoadedSuccess({required this.listTasks});
}

class TaskLoadedFail extends TaskControlState {
  final Exception exp;
  TaskLoadedFail({required this.exp});
}
