import 'package:uuid/uuid.dart';

class TeamDTO {
  TeamDTO({
    required this.displayName,
    required this.id,
  });

  final String? displayName;
  final int? id;
}
