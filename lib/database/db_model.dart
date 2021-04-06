abstract class QrscanEvent {}

class DbModel {
  int id;
  String name;
  String date;

  DbModel({this.id, this.name, this.date});

  factory DbModel.fromMap(Map<String, dynamic> json) => DbModel(
        id: json["id"],
        name: json["name"],
        date: json["date"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "date": date,
      };
}
