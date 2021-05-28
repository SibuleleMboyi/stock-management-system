import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/blocs/blocs.dart';
import 'package:stock_management_system/helpers/helpers.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/repositories.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final ProductRepository _productRepository;
  final AuthBloc _authBloc;
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;

  CartCubit({
    @required ProductRepository productRepository,
    @required AuthBloc authBloc,
    @required UserRepository userRepository,
    @required StorageRepository storageRepository,
    //ComposeEmail composeEmail,
  })  : _productRepository = productRepository,
        _authBloc = authBloc,
        _userRepository = userRepository,
        _storageRepository = storageRepository,
        //_composeEmail = composeEmail,
        super(CartState.initial());

  Future<void> products() async {
    List<Product> productsList =
        await _productRepository.fetchProductsFromCart();

    emit(state.copyWith(productsList: productsList));
  }

  Future<void> removeItem({@required String productBarCode}) async {
    await _productRepository.removeFromCart(productBarCode: productBarCode);
  }

  Future<void> signedInUser() async {
    final userId = _authBloc.state.user.uid;
    final user = await _userRepository.getUserWithId(userId: userId);
    //print('userId : ' + userId);
    emit(state.copyWith(user: user));
  }

  Future<void> submitOrder({@required String cashierId}) async {
    await _productRepository.buyProducts(
      transactionDate: 'transactionDate',
      cashierId: cashierId,
    );
    final invoice = Invoice(items: [
      Product(
        productBarCode: '000000000',
        productName: 'Java',
        productBrand: 'IDE',
        quantity: 5,
        price: 10,
      ),
      Product(
        productBarCode: '0098730000',
        productName: 'Java',
        productBrand: 'IDE',
        quantity: 5,
        price: 7,
      ),
      Product(
        productBarCode: '123400000',
        productName: 'Green',
        productBrand: 'Salad',
        quantity: 5,
        price: 1,
      ),
      Product(
        productBarCode: '000232000',
        productName: 'Olive',
        productBrand: 'Light',
        quantity: 5,
        price: 2,
      ),
    ]);
    final pdfFile = await InvoiceDocument.generateDocument(invoice: invoice);
    await _storageRepository.uploadPdfToDatabase(pdf: pdfFile);
    await EmailSender.sendEmail(pdfFilePath: SavePdf.filePath());

    signedInUser();
  }

  void reset() {
    emit(CartState.initial());
  }
}
