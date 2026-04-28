// Providery Riverpod — zarządzanie stanem i logika biznesowa dla modułu ekwipunku.
// Korzystamy z systemu generowania kodu (riverpod_annotation), aby zapewnić bezpieczeństwo typów.

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/sort_utils.dart';
import '../data/product_repository.dart';
import '../domain/product_item.dart';

part 'product_provider.g.dart';

// Udostępnia instancję repozytorium do warstwy UI/Domeny.
@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository();
}

// Strumień (Stream) aplikacji, który emituje nową listę produktów za każdym razem,
// gdy coś zmieni się w bazie danych SQLite. Dane są automatycznie sortowane wg daty ważności.
@riverpod
Stream<List<ProductItem>> sortedProducts(SortedProductsRef ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.watchActiveProducts().map(SortUtils.sortByExpiry);
}

// Licznik produktów, które kończą się wkrótce (np. w ciągu 48h).
// Używane do wyświetlania powiadomień/indykatorów na ikonie Magazynu.
@riverpod
int expiringSoonCount(ExpiringSoonCountRef ref) {
  final productsAsync = ref.watch(sortedProductsProvider);
  return productsAsync.valueOrNull?.where((p) {
    final status = SortUtils.getStatus(p);
    return status == ExpiryStatus.expiresSoon ||
        status == ExpiryStatus.expirestoday ||
        status == ExpiryStatus.expired;
  }).length ?? 0;
}

// InventoryNotifier — kontroler akcji (użytkownik dodaje, usuwa lub zużywa produkt).
// Klasa ta pośredniczy między UI a warstwą danych (Repository).
@riverpod
class InventoryNotifier extends _$InventoryNotifier {
  @override
  Future<void> build() async {
    // Metoda build inicjalizuje stan, jeśli jest to potrzebne.
  }

  // Pobieramy repozytorium (używamy read, bo nie chcemy przebudowywać Notifiera przy zmianie repo).
  ProductRepository get _repo => ref.read(productRepositoryProvider);

  // Zapisuje nowy produkt w bazie.
  Future<void> addProduct(ProductItem product) =>
      _repo.save(product);

  // Szybkie dodawanie z predefiniowanych wzorców (np. 'Mleko', 'Jajka').
  Future<void> addFromPreset(QuickStartPreset preset) =>
      _repo.addFromPreset(preset);

  // Oznacza produkt jako zużyty (przenosi do historii).
  Future<void> markConsumed(int id) =>
      _repo.markConsumed(id);

  // Całkowite usunięcie produktu z pamięci i bazy.
  Future<void> deleteProduct(int id) =>
      _repo.delete(id);
}
