import 'package:uuid/uuid.dart';

class TeamDTO {
  TeamDTO({
    required this.displayName,
    required this.uuid,
  });

  final String displayName;
  final Uuid uuid;
}
