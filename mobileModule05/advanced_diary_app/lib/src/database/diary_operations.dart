import 'database.dart';

extension DiaryOperations on Database {
  Future<void> addDiaryEntry(String title, String text, int iconIndex) async {
    if (supabase.auth.currentUser?.email == null) {
      throw Exception('User not authenticated');
    }

    await supabase.from('notes').insert({
      'icon_index': iconIndex,
      'text': text,
      'title': title,
      'usermail': supabase.auth.currentUser!.email!,
    });
  }

  Future<List<Map<String, dynamic>>> getDiaryEntries() async {
    if (supabase.auth.currentUser?.email == null) {
      throw Exception('User not authenticated');
    }

    final response = await supabase
        .from('notes')
        .select()
        .eq('usermail', supabase.auth.currentUser!.email!)
        .order('date', ascending: false);

    return response;
  }

  Future<void> deleteDiaryEntry(int id) async {
    await supabase.from('notes').delete().eq('id', id);
  }
}
