// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserController on UserControllerBase, Store {
  late final _$userAtom =
      Atom(name: 'UserControllerBase.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$isUserLoggedInAtom =
      Atom(name: 'UserControllerBase.isUserLoggedIn', context: context);

  @override
  bool get isUserLoggedIn {
    _$isUserLoggedInAtom.reportRead();
    return super.isUserLoggedIn;
  }

  @override
  set isUserLoggedIn(bool value) {
    _$isUserLoggedInAtom.reportWrite(value, super.isUserLoggedIn, () {
      super.isUserLoggedIn = value;
    });
  }

  late final _$teamAtom =
      Atom(name: 'UserControllerBase.team', context: context);

  @override
  TeamDTO? get team {
    _$teamAtom.reportRead();
    return super.team;
  }

  @override
  set team(TeamDTO? value) {
    _$teamAtom.reportWrite(value, super.team, () {
      super.team = value;
    });
  }

  late final _$UserControllerBaseActionController =
      ActionController(name: 'UserControllerBase', context: context);

  @override
  User? fetchUser() {
    final _$actionInfo = _$UserControllerBaseActionController.startAction(
        name: 'UserControllerBase.fetchUser');
    try {
      return super.fetchUser();
    } finally {
      _$UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  TeamDTO? fetchTeam() {
    final _$actionInfo = _$UserControllerBaseActionController.startAction(
        name: 'UserControllerBase.fetchTeam');
    try {
      return super.fetchTeam();
    } finally {
      _$UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
isUserLoggedIn: ${isUserLoggedIn},
team: ${team}
    ''';
  }
}
