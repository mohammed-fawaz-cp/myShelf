import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/i_favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements IFavoritesRepository {
  final IFavoritesLocalDataSource _localDataSource;

  FavoritesRepositoryImpl(this._localDataSource);

  @override
  Future<List<int>> getFavorites() async {
    return _localDataSource.getFavorites();
  }

  @override
  Future<void> saveFavorites(List<int> ids) async {
    await _localDataSource.saveFavorites(ids);
  }
}

final favoritesRepositoryProvider = Provider<IFavoritesRepository>((ref) {
  final localDataSource = ref.watch(favoritesLocalDataSourceProvider);
  return FavoritesRepositoryImpl(localDataSource);
});
