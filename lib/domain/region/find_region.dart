
import 'package:groundjp/component/region_data.dart';
import 'package:groundjp/domain/enums/language_enum.dart';


class FindRegion {

  static List<Region> search(String word) {
    LanguageType langType = LanguageType.getLangType(word);
    List<Region> result = [];

    word = word.toLowerCase();

    Region.values
        .where((region) => region != Region.ALL && region.isStartWith(langType, word))
        .forEach((region) => result.add(region));

    if (result.isEmpty) {
      RegionParent.values
          .where((regionParent) => regionParent != RegionParent.ALL && regionParent.isStartWith(langType, word))
          .forEach((regionParent) => result.addAll(regionParent.getRegionChildList()));
    }

    result.sort((a, b) => a.compareTo(b, langType));

    return result;
  }

}