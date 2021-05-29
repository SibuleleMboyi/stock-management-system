import 'package:stock_management_system/models/models.dart';

abstract class BaseProductRepository {
  Future<Product> isProductAvailable();
  Future<void> addNewStockProduct();
  Future<void> updateStockProduct();
  Future<void> addProductToCart();
  Future<void> removeFromCart();
  Future<void> buyProducts();
  Future<int> getInvoiceNumber();
}
