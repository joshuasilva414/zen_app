import 'package:zen_app/db.dart';

class EntryRepository {
  Future<List<String>> getAllEntryDates() async {
    final db = await DatabaseInstance.instance.db;

    final res = await db.query("entries", columns: ["timestamp"]);

    return res.map((e) => e["timestamp"] as String).toList();
  }

  Future<List<String>> getAllEntryDatesSorted() async {
    final db = await DatabaseInstance.instance.db;

    final res = await db.query(
      "entries",
      columns: ["timestamp"],
      orderBy: "timestamp ASC",
    );

    return res.map((e) => e["timestamp"] as String).toList();
  }

  Future<int> insertEntry(String prompt, String timestamp, String content) async {
    final db = await DatabaseInstance.instance.db;
    final data = {
      "prompt": prompt,
      "timestamp": timestamp,
      "content": content
    };
    return await db.insert("entries", data);
  }

  Future<bool> isEmpty() async {
    final db = await DatabaseInstance.instance.db;
    final res = await db.query("entries", limit: 1);
    return res.isEmpty;
  }

  Future<Map<String, dynamic>?> getEntryByDate(String date) async {
    final db = await DatabaseInstance.instance.db;
    final res = await db.query("entries", where: " timestamp = ?", whereArgs: [date], limit: 1);
    if (res.isEmpty) {
      return null;
    }
    return res.first;
  }

  Future<void> seedDummyEntries() async {
    final db = await DatabaseInstance.instance.db;

    final data = [
      {
        "prompt": "How was your day?",
        "timestamp": "2025-11-11",
        "content": "This is a test entry for November 11."
      },
      {
        "prompt": "What did you learn?",
        "timestamp": "2025-11-24",
        "content": "This is a test entry for November 24."
      },
      {
        "prompt": "What are you grateful for?",
        "timestamp": "2025-11-30",
        "content": "This is another test entry."
      }
    ];

    for (final row in data) {
      await db.insert("entries", row);
    }
  }

  Future<int> updateEntry(int id, Map<String, dynamic> data) async {
    final db = await DatabaseInstance.instance.db;
    return db.update(
      "entries",
      data,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
