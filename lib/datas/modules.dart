class Task {
  String title;
  bool isCompleted;
  String note;
  Task({required this.title, this.isCompleted = false, this.note = ''});

  Task copyWith(String? title, bool? isCompleted, String? note) {
    return Task(
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
        note: note ?? this.note);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'note': note,
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
        title: json['title'],
        isCompleted: json['isCompleted'],
        note: json['note']);
  }
}
