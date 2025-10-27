class Pokemon {
  final int id;
  final String name; // english
  final List<String> type;
  final Map<String, int> base;
  final int generation; // 1..9
  final String? imageAsset; // we store a URL (thumbnail/sprite)
  final Map<String, dynamic>? evolution; // <-- NEW

  Pokemon({
    required this.id,
    required this.name,
    required this.type,
    required this.base,
    required this.generation,
    this.imageAsset,
    this.evolution, // <-- NEW
  });

  factory Pokemon.fromJson(Map<String, dynamic> j) {
    final name =
        (j['name']?['english'] as String?) ?? j['name']?.toString() ?? '';
    final id = j['id'] is int
        ? j['id'] as int
        : int.tryParse('${j['id']}') ?? 0;
    int gen = j['generation'] is int ? j['generation'] : _deriveGen(id);

    return Pokemon(
      id: id,
      name: name,
      type:
          (j['type'] as List?)?.map((e) => '$e').cast<String>().toList() ??
          const [],
      base:
          (j['base'] as Map?)?.map(
            (k, v) => MapEntry('$k', int.tryParse('$v') ?? 0),
          ) ??
          {},
      generation: gen,
      imageAsset:
          (j['image']?['thumbnail'] as String?) ??
          (j['image']?['sprite'] as String?),
      evolution: j['evolution'] as Map<String, dynamic>?, // <-- NEW
    );
  }

  static int _deriveGen(int id) {
    if (id <= 151) return 1;
    if (id <= 251) return 2;
    if (id <= 386) return 3;
    if (id <= 493) return 4;
    if (id <= 649) return 5;
    if (id <= 721) return 6;
    if (id <= 809) return 7;
    if (id <= 905) return 8;
    return 9;
  }
}
