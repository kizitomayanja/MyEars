class Sessions {
  final int id;
  final String date;
  final String startHour;
  final String endHour;
  final String title;

  const Sessions(
      {required this.title,
      required this.date, //dates should be in format yyyy-m-d
      required this.startHour,
      required this.endHour,
      required this.id});

  factory Sessions.fromJson(Map<String, dynamic> json) => Sessions(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      startHour: json['startHour'],
      endHour: json['endHour']);
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'startHour': startHour,
        'endHour': endHour,
      };
}
