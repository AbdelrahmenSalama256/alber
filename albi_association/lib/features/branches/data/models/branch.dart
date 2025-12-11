class Branch {
  final int id;
  final String name;

  Branch({required this.id, required this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    final dynamic idVal = json['id'] ?? json['branch_id'];
    int parsedId = 0;
    if (idVal is int) parsedId = idVal;
    if (idVal is double) parsedId = idVal.toInt();
    if (idVal is String) parsedId = int.tryParse(idVal) ?? 0;

    final String parsedName = (json['name'] ??
            json['branch_name'] ??
            json['title'] ??
            json['label'] ??
            '')
        .toString();

    return Branch(id: parsedId, name: parsedName);
  }
}

