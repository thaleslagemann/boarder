import 'dart:convert';
import 'dart:core';

class UserModel {
  UserModel({this.id, this.name, this.email, this.phone, this.photoUrl, this.teams, this.boards});

  String? id;
  String? name;
  String? email;
  String? phone;
  String? photoUrl;
  List<int>? teams;
  List<int>? boards;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'teams': teams,
      'boards': boards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      photoUrl: map['photoUrl'],
      teams: map['teams'].toList<int>(),
      boards: map['boards'].toList<int>(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
