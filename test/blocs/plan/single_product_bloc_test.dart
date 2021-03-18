import 'package:bloc_test/bloc_test.dart';
import 'package:my_lawn/blocs/single_product/single_product_bloc.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/services/single_product/single_product_service_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockSingleProductService extends Mock implements SingleProductService {}

void main() {
  group('Test SingleProductBloc', () {
    SingleProductBloc singleProductBloc;
    SingleProductService singleProductService;

    setUp(() {
      singleProductService = MockSingleProductService();
      singleProductBloc = SingleProductBloc(singleProductService);
    });

    test('Initial state is SingleProductBlocInitial', () {
      expect(singleProductBloc.state, SingleProductInitial());
      singleProductBloc.close();
    });

    group('Get Product', () {
      final category = 'pro12312';
      final productId = 'drupalproductid';
      final productWithSku = SingleProductResponse(name: 'name', sku: '123123');
      final product = Product();

      setUp(() {
        when(singleProductService.getProductSku(variables: {
          'category': category,
          'code': productId,
        })).thenAnswer((_) async => productWithSku);
        when(singleProductService.getProduct(product: productWithSku))
            .thenAnswer((_) async => product);
      });
      blocTest<SingleProductBloc, SingleProductState>(
        'invokes singleProductService getProductSku',
        build: () => singleProductBloc,
        act: (bloc) => bloc.add(SingleProductLoad(
          category: category,
          productId: productId,
        )),
        verify: (_) {
          verify(singleProductService.getProductSku(variables: {
            'category': category,
            'code': productId,
          })).called(1);
        },
      );
      blocTest<SingleProductBloc, SingleProductState>(
        'invokes singleProductService getProduct',
        build: () => singleProductBloc,
        act: (bloc) => bloc.add(SingleProductLoad(
          category: category,
          productId: productId,
        )),
        verify: (_) {
          verify(singleProductService.getProduct(product: productWithSku))
              .called(1);
        },
      );
    });

    group('Final state is SingleProductBlocInitial', () {
      final category = 'pro12312';
      final productId = 'drupalproductid';
      final productWithSku = SingleProductResponse(name: 'name', sku: '123123');
      final product = Product();

      setUp(() {
        when(singleProductService.getProductSku(variables: {
          'category': category,
          'code': productId,
        })).thenAnswer((_) async => productWithSku);
        when(singleProductService.getProduct(product: productWithSku))
            .thenAnswer((_) async => product);
        singleProductBloc
            .add(SingleProductLoad(category: category, productId: productId));
      });
      blocTest<SingleProductBloc, SingleProductState>(
          'invokes SingleProductBlocInitial',
          build: () => singleProductBloc,
          act: (bloc) => bloc.add(SingleProductOpened()),
          expect: <SingleProductState>[
            SingleProductLoading(),
            SingleProductSuccess(product: product),
            SingleProductInitial(),
          ]);
    });
  });
}
