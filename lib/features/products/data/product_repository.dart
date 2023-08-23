import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_store/api/api_error.dart';
import 'package:riverpod_store/api/dio_provider.dart';
import 'package:riverpod_store/features/products/domain/entities/product.dart';

part 'product_repository.g.dart';

class ProductRepository {
  ProductRepository({required this.dio});
  final Dio dio;

  Future<List<Product>> fetchProducts({CancelToken? cancelToken}) => _run(
        request: () => dio.get(
          'https://fakestoreapi.com/products',
          cancelToken: cancelToken,
        ),
        parse: (data) {
          final products = data as List<dynamic>;
          return products.map((product) => Product.fromJson(product)).toList();
        },
      );

  Future<T> _run<T>({
    required Future<Response> Function() request,
    required T Function(dynamic) parse,
  }) async {
    try {
      // add artificial delay to test loading UI
      //await Future.delayed(const Duration(seconds: 1));
      final response = await request();
      switch (response.statusCode) {
        case 200:
          return parse(response.data);
        case 404:
          throw const APIError.notFound();
        default:
          throw const APIError.unknown();
      }
    } on SocketException catch (_) {
      throw const APIError.noInternetConnection();
    }
  }
}

@riverpod
ProductRepository productsRepository(ProductsRepositoryRef ref) {
  return ProductRepository(dio: ref.watch(dioProvider));
}

@riverpod
Future<List<Product>> fetchProducts(FetchProductsRef ref) {
  return ref.watch(productsRepositoryProvider).fetchProducts();
}
