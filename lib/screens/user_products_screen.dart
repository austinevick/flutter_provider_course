import 'package:flutter/material.dart';
import 'package:flutter_provider/providers/products.dart';
import 'package:flutter_provider/widgets/app_drawer.dart';
import 'package:flutter_provider/widgets/user_products_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: product.items.length,
            itemBuilder: (context, i) {
              return UserProductsItem(
                title: product.items[i].title,
                imageUrl: product.items[i].imageUrl,
              );
            }),
      ),
    );
  }
}
