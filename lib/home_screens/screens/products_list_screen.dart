import 'dart:async';
import 'dart:math';
import 'package:ayni_flutter_app/feature_orders/screens/sales_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:ayni_flutter_app/home_screens/screens/crops_list_screen.dart';
import 'package:ayni_flutter_app/home_screens/services/products_service.dart';
import 'package:ayni_flutter_app/home_screens/models/products.dart';
import 'package:ayni_flutter_app/feature_profile/screens/transaction_panels.dart';
import 'package:ayni_flutter_app/shared/widgets/bottom_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final ProductsService _productsService = ProductsService();
  List<Products> _products = [];
  List<Products> _shuffledProducts = [];
  List<Products> _searchResults = [];
  bool _isLoading = true;
  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _startShuffleTimer();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _startShuffleTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      _shuffleProducts();
    });
  }

  Future<void> _fetchProducts() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getInt('userId');
    
    List<Products> products = await _productsService.getAll();
    List<Products> filteredProducts = products.where((product) {
      return product.userId == userId;
    }).toList();
    setState(() {
      _products = filteredProducts;
      _shuffledProducts = List.of(filteredProducts);
      _isLoading = false;
    });
  }

  void _shuffleProducts() {
    setState(() {
      _shuffledProducts.shuffle(Random());
    });
  }

  void _onSearchChanged() {
    String searchQuery = _searchController.text.toLowerCase();
    setState(() {
      if (searchQuery.isEmpty) {
        _searchResults.clear();
      } else {
        _searchResults = _products.where((product) {
          return product.name.toLowerCase().contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome',
                      style: TextStyle(fontSize: 35),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          const Text('Find your product',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    hintText: 'Search',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search, color: Colors.white),
                                onPressed: _onSearchChanged,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _searchController.text.isNotEmpty
                      ? _buildSearchResults()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Latest Crops', style: TextStyle(fontSize: 24)),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const CropsListScreen()),
                                      );
                                    },
                                    child: const Text('See All ->',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _shuffledProducts.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image.network(
                                              _shuffledProducts[index].imageUrl,
                                              width: 100,
                                              height: 150,
                                              fit: BoxFit.cover),
                                        ),
                                        Positioned(
                                          top: 8.0,
                                          left: 8.0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4.0),
                                            child: Text(
                                              _shuffledProducts[index].name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text('Products On Sale',
                                  style: TextStyle(fontSize: 24)),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _products.length,
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.all(8.0),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_products[index].name,
                                          style: const TextStyle(fontSize: 16)),
                                      Text(
                                        _products[index].description.length > 50
                                            ? '${_products[index].description
                                                    .substring(0, 50)}...'
                                            : _products[index].description,
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  trailing: ClipOval(
                                    child: Image.network(_products[index].imageUrl,
                                        width: 50, height: 50, fit: BoxFit.cover),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavBar(currentIndex: 0, 
            onTap: (index){
          switch(index){
            case 0:
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ProductsListScreen()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const CropsListScreen()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const SalesListScreen()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const TransactionListScreen2()));
              break;
          }
        }),
    );
  }

  Widget _buildSearchResults() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: const EdgeInsets.all(8.0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_searchResults[index].name, style: const TextStyle(fontSize: 16)),
              Text(
                _searchResults[index].description.length > 50
                    ? '${_searchResults[index].description.substring(0, 50)}...'
                    : _searchResults[index].description,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          trailing: ClipOval(
            child: Image.network(_searchResults[index].imageUrl,
                width: 50, height: 50, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}