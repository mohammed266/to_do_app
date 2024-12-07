class Task {
  int? id;
  String title;
  String date;
  String status;

  Task({this.id, required this.title, required this.date, required this.status});

  // Convert a Task object into a Map object for sqflite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'status': status,
    };
  }

  // Convert a Map object into a Task object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      status: map['status'],
    );
  }
}