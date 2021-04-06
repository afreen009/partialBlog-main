import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserCredentials {
  String name;
  String userId;
  String pictureUrl;
  String email;

  UserCredentials({
    @required this.userId,
    @required this.name,
    @required this.pictureUrl,
    @required this.email,
  });

  UserCredentials.fromJson(Map<String, String> data) {
    this.name = data["name"];
    this.pictureUrl = data['pictureUrl'];
    this.email = data['email'];
  }

  Map<String, String> toJson() =>
      {"name": this.name, "pictureUrl": this.pictureUrl, "email": this.email};

  @override
  String toString() {
    return json.encode(this.toJson());
  }
}
