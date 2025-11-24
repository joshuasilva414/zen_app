class Prompt {
    final int id;
    final String content;

    const Prompt({this.id, this.content});

    Map<String, Object?> toMap() {
        return {'id': id, 'content': content};
    }

    @override
    String toString() {
        return 'Prompt{id: $id, content: $content}';
    }
}

Future<void> insertPrompt(Prompt prompt) async {
    final db = await DatabaseInstance().db;
    await db.insert('prompts', prompt.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> updatePrompt(Prompt prompt) async {
    final db = await DatabaseInstance().db;
    await db.update('prompts', prompt.toMap(), where: 'id = ?', whereArgs: [prompt.id]);
}

Future<void> deletePrompt(int id) async {
    final db = await DatabaseInstance().db;
    await db.delete('prompts', where: 'id = ?', whereArgs: [id]);
}

Future<Prompt> getPrompt(int id) async {
    final db = await DatabaseInstance().db;
    final List<Map<String, Object?>> prompts = await db.query('prompts', where: 'id = ?', whereArgs: [id]);
    return prompts.map((prompt) => Prompt.fromMap(prompt)).first;
}

Future<List<Prompt>> getAllPrompts() async {
    final db = await DatabaseInstance().db;
    final List<Map<String, Object?>> prompts = await db.query('prompts');
    return prompts.map((prompt) => Prompt.fromMap(prompt)).toList();
}
