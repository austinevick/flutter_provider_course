import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Bag',
      description: 'POLESTAR Noble blue school/laptop backpack',
      price: 69.99,
      imageUrl:
          'https://images-na.ssl-images-amazon.com/images/I/91ArJudYdDL._SL1500_.jpg',
    ),
    Product(
      id: 'p6',
      title: 'Iphone 8 plus',
      description: 'Iphone 8 plus 5.5-Inch',
      price: 129.99,
      imageUrl:
          'https://ng.jumia.is/unsafe/fit-in/680x680/filters:fill(white)/product/65/380942/3.jpg?2165',
    ),
    Product(
        id: 'p7',
        title: 'Computer',
        description: 'HP pro one 600 All-in-one',
        price: 200.56,
        imageUrl:
            'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c06423994.png?imwidth=248&imdensity=1'),
    Product(
        id: 'p8',
        title: 'Keyboard',
        description: 'Light Keyboard',
        price: 89.99,
        imageUrl:
            'https://store.hp.com/app/assets/images/uploads/prod/how-to-turn-keyboard-lighting-on-off-hero1561055925107573.png')
  */
  ];

  static const url =
      'https://flutter-ecommerce-62616.firebaseio.com/products.json';

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
      final Map<String, dynamic> result = jsonDecode(response.body);
      final List<Product> loadedProducts = [];
      result.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFavorite: value['isFavorite'],
            imageUrl: value['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavorite
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  updateProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      final url = 'https://flutter-ecommerce-62616.firebaseio.com/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      _items[prodIndex] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final url = 'https://flutter-ecommerce-62616.firebaseio.com/$id.json';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    http.delete(url).then((_) => existingProduct = null).catchError(
        (_) => _items.insert(existingProductIndex, existingProduct));
    //_items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
