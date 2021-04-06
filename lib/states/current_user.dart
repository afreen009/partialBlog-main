import 'dart:convert';

import 'package:flutter/material.dart';

class UserData {
  String name;
  //Where is store the userid in that model ? or not store yet ?
  int points = 0;
  List<dynamic> channels = []; //Default value will be an empty List

  UserData({
    @required this.name,
    this.points: 0,
    this.channels,
  });
  //which version of flutter are currently using ?  okay I saw th thought enable null safety np

  UserData.fromJson(Map<String, dynamic> jsonObj) {
    this.name = jsonObj['name'] ?? '';
    this.points = jsonObj['points'] ?? 0;
    this.channels = jsonObj['channel'] ?? [];
  }

  Map<String, dynamic> toJson() =>
      {'name': this.name, 'points': this.points, 'channel': this.channels};

  //we can override the toString method for easy encode
  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
