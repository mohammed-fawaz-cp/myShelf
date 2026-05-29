import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/theme_provider.dart';

abstract class IFavoritesLocalDataSource {
  List<int> getFavorites();
  Future<void> saveFavorites(List<int> ids);
}

class FavoritesLocalDataSourceImpl implements IFavoritesLocalDataSource {
  final SharedPreferences _prefs;
  static const _favoritesKey = 'favorite_product_ids';

  FavoritesLocalDataSourceImpl(this._prefs);

  @override
  List<int> getFavorites() {
    final list = _prefs.getStringList(_favoritesKey) ?? [];
    return list
        .map((idStr) => int.tryParse(idStr) ?? 0)
        .where((id) => id != 0)
        .toList();
  }

  @override
  Future<void> saveFavorites(List<int> ids) async {
    final list = ids.map((id) => id.toString()).toList();
    await _prefs.setStringList(_favoritesKey, list);
  }
}

final favoritesLocalDataSourceProvider = Provider<IFavoritesLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesLocalDataSourceImpl(prefs);
});
