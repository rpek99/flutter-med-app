class EventDetail {
  late String id;
  late String description;
  late String date;
  late String startTime;
  late String endTime;
  late String speaker;
  late String isFavorite;

  EventDetail(this.id, this.description, this.date, this.startTime,
      this.speaker, this.endTime, this.isFavorite);

  EventDetail.fromMap(dynamic obj) {
    id = obj.id;
    description = obj['description'];
    date = obj['date'];
    startTime = obj['start_time'];
    speaker = obj['speaker'];
    endTime = obj['end_time'];
    isFavorite = obj['is_favorite'].toString();
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['description'] = description;
    map['date'] = date;
    map['start_time'] = startTime;
    map['end_time'] = endTime;
    map['speaker'] = speaker;
    map['is_favorite'] = isFavorite;
    return map;
  }
}
