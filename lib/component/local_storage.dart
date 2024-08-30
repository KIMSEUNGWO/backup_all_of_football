import 'package:groundjp/component/region_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {

  static const LocalStorage instance = LocalStorage();
  const LocalStorage();

  Future<Region> findByRegion() async {
    final storage = await SharedPreferences.getInstance();
    String? regionName = storage.getString(LocalStorageKey.REGION.name);
    return Region.findByName(regionName);
  }

  saveByRegion(Region region) async {
    final storage = await SharedPreferences.getInstance();
    storage.setString(LocalStorageKey.REGION.name, region.name);
  }

  Future<List<String>> getRecentlySearchWords() async{
    final storage = await SharedPreferences.getInstance();
    List<String>? words = storage.getStringList(LocalStorageKey.RECENTLY_SEARCH_WORD.name);
    return (words == null) ? [] : words;
  }

  saveByRecentlySearchWord(List<String> words) async {
    final storage = await SharedPreferences.getInstance();
    if (words.length > 6) words = words.sublist(0, 6);
    storage.setStringList(LocalStorageKey.RECENTLY_SEARCH_WORD.name, words);
  }


}

enum LocalStorageKey {

  REGION,
  RECENTLY_SEARCH_WORD,

}