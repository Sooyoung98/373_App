class Event {
  final String? title;
  final String? location;
  final DateTime? date;
  final int? color;
  final String? endTime;
  final String? startTime;
  final String? repeatType;
  final String? description;

  Event(
      {this.title,
      this.location,
      this.date,
      this.color,
      this.endTime,
      this.startTime,
      this.repeatType,
      this.description});

  Event.fromData(Map<String, dynamic> data)
      : title = data['title'],
        location = data['location'],
        date = data['date'],
        color = data['color'],
        endTime = data['endTime'],
        startTime = data['startTime'],
        repeatType = data['repeatType'],
        description = data['description'];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'date': date,
      'color': color,
      'endTime': endTime,
      'startTime': startTime,
      'repeatType': repeatType,
      'description': description
    };
  }
}
