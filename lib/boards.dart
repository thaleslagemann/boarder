class Boards {
  final String name;
  final String description;

  Boards(this.name, this.description);

  Boards.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };
}