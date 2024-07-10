import 'package:get_storage/get_storage.dart';

class DbProvider {
  GetStorage? _store;
  final String boxName;
  DbProvider(this.boxName) {
    initDb();
  }

  initDb() async {
    if (_store != null) {
      return;
    }
    _store = GetStorage(boxName);
  }

  saveBookMark(String id, String bookMark) async {
    await _store?.write(id, bookMark);
  }

  removeBookMark(String id) => _store?.remove(id);

  dynamic allBookMarks() => _store?.getValues();

  dynamic allKeys() => _store?.getKeys();
}
