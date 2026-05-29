import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/i_favorites_repository.dart';
import '../../data/repositories/favorites_repository.dart';

class FavoritesNotifier extends StateNotifier<List<int>> {
  final IFavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final list = await _repository.getFavorites();
    state = list;
  }

  Future<void> toggleFavorite(int productId) async {
    final updated = List<int>.from(state);
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = updated;
    await _repository.saveFavorites(updated);
  }

  bool isFavorite(int productId) {
    return state.contains(productId);
  }
}

final favoritesControllerProvider = StateNotifierProvider<FavoritesNotifier, List<int>>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repository);
});
