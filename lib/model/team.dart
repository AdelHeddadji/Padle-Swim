class Team {
  String teamName;
  String teamId;
  String teamImage;
  List members = [];
  List coaches = [];
  Team();

  Team.fromMap(Map<dynamic, dynamic> data) {
    teamId = data['teamId'];
    teamName = data['teamName'];
    members = data['members'];
    coaches = data['coaches'];
    teamImage = data['teamImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'teamId': teamId,
      'teamName': teamName,
      'members': members,
      'coaches': coaches,
      'teamImage': teamImage
    };
  }
}