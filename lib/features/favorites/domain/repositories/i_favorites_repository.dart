abstract class IFavoritesRepository {
  Future<List<int>> getFavorites();
  Future<void> saveFavorites(List<int> ids);
}
