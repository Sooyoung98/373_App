class Event {
  final String? id;
  final String? title;
  final String? location;
  final DateTime? date;
  final int? color;
  final String? endTime;
  final String? startTime;
  final String? repeatType;
  final String? description;
  final bool? active;
  final List<dynamic>? users;

  Event(
      {this.id,
      this.title,
      this.location,
      this.date,
      this.color,
      this.endTime,
      this.startTime,
      this.repeatType,
      this.description,
      this.active,
      this.users});

  Event.fromData(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        location = data['location'],
        date = data['date'],
        color = data['color'],
        endTime = data['endTime'],
        startTime = data['startTime'],
        repeatType = data['repeatType'],
        description = data['description'],
        active = data['active'],
        users = data['users'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'date': date,
      'color': color,
      'endTime': endTime,
      'startTime': startTime,
      'repeatType': repeatType,
      'description': description,
      'active': active,
      'users': users
    };
  }
}
