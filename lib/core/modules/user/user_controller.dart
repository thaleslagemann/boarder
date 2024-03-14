import 'package:boarder/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';

import '../team/teamDTO.dart';

part 'user_controller.g.dart';

class UserController = UserControllerBase with _$UserController;

abstract class UserControllerBase with Store {
  UserControllerBase({
    this.user,
  });

  List<TeamDTO> teams = [TeamDTO(displayName: 'Boarder', uuid: Uuid())];

  @observable
  User? user;

  @observable
  bool isUserLoggedIn = false;

  @observable
  TeamDTO? team = TeamDTO(displayName: 'Boarder', uuid: Uuid());

  @action
  User? fetchUser() {
    try {
      user = FirebaseAuth.instance.currentUser;
      isUserLoggedIn = true;
    } catch (e) {
      print(e);
    }
    return user;
  }

  @action
  TeamDTO? fetchTeam() {
    try {
      team = teams[0];
    } catch (e) {
      print(e);
    }
    return team;
  }

  @action
  getCurrentUserPicture() {
    if (isUserLoggedIn) {
      return Observer(
        builder: (_) => Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(user!.photoURL!),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.deepPurple[800],
          ),
          child: Image(image: AssetImage('assets/images/boar.png')));
    }
  }
}
