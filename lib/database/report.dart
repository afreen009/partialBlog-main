/*A class defining medicine details for reminders*/
class Report {
  //final int ids;
  final String description;

  Report({
    //this.ids,
    this.description,
  });

  factory Report.fromMap(Map<String, dynamic> json) => new Report(
      //ids: json["ids"],
      description: json["description"]);

  Map<String, dynamic> toMap() {
    return {
      //"ids": this.ids,
      "description": this.description
    };
  }
}
