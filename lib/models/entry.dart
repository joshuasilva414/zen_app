class Entry {
    final int id;
    final String prompt;
    final int timestamp;
    final String content;

    const Entry({required this.id, required this.prompt, required this.timestamp, required this.content});

    Map<String, Object?> toMap() {
        return {'id': id, 'prompt': prompt, 'timestamp': timestamp, 'content': content};
    }

    @override
    String toString() {
        return 'Entry{id: $id, prompt: $prompt, timestamp: $timestamp, content: $content}';
    }
}

Future<void> insertEntry(Entry entry) async {
    final db = await DatabaseInstance().db;
    await db.insert('entries', entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<void> updateEntry(Entry entry) async {
    final db = await DatabaseInstance().db;
    await db.update('entries', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
}

Future<void> deleteEntry(int id) async {
    final db = await DatabaseInstance().db;
    await db.delete('entries', where: 'id = ?', whereArgs: [id]);
}

Future<Entry> getEntry(int id) async {
    final db = await DatabaseInstance().db;
    final List<Map<String, Object?>> entries = await db.query('entries', where: 'id = ?', whereArgs: [id]);
    return entries.map((entry) => Entry.fromMap(entry)).first;
}

Future<List<Entry>> getAllEntries() async {
    final db = await DatabaseInstance().db;
    final List<Map<String, Object?>> entries = await db.query('entries');
    return entries.map((entry) => Entry.fromMap(entry)).toList();
}
