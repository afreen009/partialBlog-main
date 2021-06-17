import 'dart:convert';

import 'package:flutter/material.dart';

class UserData {
  String name;
  String userId;
  String pictureUrl;
  String email;
  String phoneNumber;
  int points;
  List<dynamic> channels;

  UserData({
    @required this.name,
    @required this.userId,
    @required this.email,
    @required this.pictureUrl,
    this.phoneNumber,
    this.points: 0,
    this.channels,
  });

  UserData.fromJson(Map<String, dynamic> jsonObj) {
    this.name = jsonObj['name'] ?? '';
    this.email = jsonObj['email'] ?? '';
    this.pictureUrl = jsonObj['pictureUrl'] ?? '';
    this.phoneNumber = jsonObj['phoneNumber'] ?? '';
    this.userId = jsonObj['userId'];
    this.points = jsonObj['points'] ?? 0;
    this.channels = jsonObj['channel'] ?? [];
  }

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'points': this.points,
        'channel': this.channels,
        'pictureUrl': this.pictureUrl,
        'phoneNumber': this.phoneNumber,
        'email': this.email,
        'userId': this.userId
      };

  //we can override the toString method for easy encode
  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
