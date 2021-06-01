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
    emit(state.copyWith(user: user));
  }

  Future<void> submitOrder() async {
    emit(state.copyWith(status: CartStatus.submitting));
    try {
      await signedInUser();

      final int transactionNumber = await _productRepository.getInvoiceNumber();

      final transaction = Transaction_(
        transactionNumber: transactionNumber.toString(),
        date: Formats.dateFormat(),
        author: 'users/' + state.user.id,
        items: state.productsList,
      );
      final pdfFile = await InvoiceDocument.generateDocument(
        transaction: transaction,
        user: state.user,
      );

      await _productRepository.buyProducts(
        cashierId: state.user.id,
      );

      await _storageRepository.uploadPdfToDatabase(
        pdf: pdfFile,
        transaction: transaction,
      );

      await EmailSender.sendEmail(pdfFilePath: SavePdf.filePath());
      emit(state.copyWith(status: CartStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(
          status: CartStatus.error,
          failure: Failure(message: err.message, code: err.code)));
    }
  }

  void reset() {
    emit(CartState.initial());
  }
}
