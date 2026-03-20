import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_trade_window/models/datas.dart';
import 'package:flutter_trade_window/screens/stock_details_page.dart';
import 'package:flutter_trade_window/services/api_services.dart';
import 'package:flutter_trade_window/widgets/stock_widgets.dart';


class WishListPage extends StatefulWidget {
  @override
  State<WishListPage> createState() => _WishListPageState();
}
 
class _WishListPageState extends State<WishListPage> {

 Timer? _refreshTimer; // 1. Define the timer
 
  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _fetchWishlist();
        });
      }
    });
  }
 
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  bool isLoading = true;
 

 
  // Load symbols from DB and filter your local stock data
  Future<void> _fetchWishlist() async {
    try {
      List<String> symbols = await ApiService.fetchWishList();
      setState(() {
        likedStock = allStocks.where((s) => symbols.contains(s.symbol)).toList();
        for (var s in likedStock) { s.like = true; }
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching wishlist: $e");
      setState(() => isLoading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist"),titleSpacing:32,backgroundColor: Color(0xFF1e3c72),titleTextStyle: TextStyle(color: Colors.white70, fontSize: 28, fontWeight: FontWeight.w400,letterSpacing:1.5),foregroundColor: Colors.white,),
      backgroundColor: Colors.grey.shade100,
      body: likedStock.isEmpty 
        ? const Center(child: Text("No liked stocks yet!"))
        : ListView.builder(
            itemCount: likedStock.length,
            itemBuilder: (context, index) {
              final stock = likedStock[index];
              return StockCard(
                stock: stock,
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(
                     builder: (context) => StockDetailPage(
                       symbol: stock.symbol, 
                       name: stock.name, 
                       price: stock.price, 
                       change: stock.change, 
                       priceHistory: stock.priceHistory
                     )));
                },
                onLikeToggle: () async{
                  await ApiService.toggleWishlist(stock.symbol);
                  setState(() {
                    stock.like=false;
                    likedStock.removeAt(index);
                  });
                },
              );
            },
          ),
    );
  }
}
 