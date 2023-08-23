import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_store/features/products/data/product_repository.dart';

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(fetchProductsProvider);
    return productAsync.when(
      data: (products) => ListView.separated(
        itemBuilder: (context, index) {
          final product = products[index];
          return Text(product.title);
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: products.length,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text(e.toString())),
    );
  }
}
