

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_trade_window/models/datas.dart';
import 'package:flutter_trade_window/screens/stock_details_page.dart';
import 'package:flutter_trade_window/services/api_services.dart';
import 'package:flutter_trade_window/widgets/stock_widgets.dart';


class TradeVaultHome extends StatefulWidget {
  const TradeVaultHome({super.key});
 
  @override
  State<TradeVaultHome> createState() => _TradeVaultHomeState();
}
 
class _TradeVaultHomeState extends State<TradeVaultHome> {



  @override
  void initState() {
    super.initState();
    
    displayStocks=allStocks;

    priceTimer=Timer.periodic(Duration(seconds: 1), (timer){simulateMarketMovement();});
    for (var stocks in allStocks){
      if(stocks.priceHistory.isEmpty){
        stocks.priceHistory.add(stocks.price);
      }
    }
  }
  void loadData() async {
  double balance = await ApiService.fetchBalance();
  currentAmount =  StockUtils().totalCurrentAmount();
  
  await ApiService.syncPortfolio();
  setState(() {
    tradeAccountBalance = balance;
  });
  }


  void applyCombinedFilters() {
  setState(() {
      displayStocks = StockUtils.filterStocks(
      allStocks: allStocks,
      category: selectedCategory,
      query: currentSearchQuery,
    );
  });
  }


  void simulateMarketMovement(){
    setState(() {
      for (var i=0;i<allStocks.length;i++){
        double movement=(random.nextDouble()-0.5)*0.01;
        double newPrize =allStocks[i].price+(allStocks[i].price*movement);

        allStocks[i].price=double.parse(newPrize.toStringAsFixed(2));
        allStocks[i].change=double.parse((allStocks[i].change+(movement*100)).toStringAsFixed(2));

        allStocks[i].priceHistory.add(allStocks[i].price);
        if(allStocks[i].priceHistory.length>20){
          allStocks[i].priceHistory.removeAt(0);
        }  
      }
      investedAmount = 0;
      
      for (var owned in ownedStock) {
        investedAmount += (owned.avgPrice * owned.quantity);
      }
      loadData();
      
      applyCombinedFilters();
    });
      
      
     
  }

  @override
  void dispose() {

    priceTimer?.cancel();
    searchController.clear();
    super.dispose();
  }


 
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade100,
    body: Column(
      children: [
        // 1. Using the new CustomHeader
        CustomHeader(
          title: "Stock Market",
          subtitle: "Explore",
           
          
          
          
        ),
 
        // Search Bar (Transformed)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Transform.translate(
            offset: const Offset(0, -25),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                currentSearchQuery = value;
                applyCombinedFilters();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search Stocks...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: currentSearchQuery.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        currentSearchQuery = "";
                        applyCombinedFilters();
                      }) 
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
 
        // 2. Using the new CustomFilterChip
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          child: Row(
            children: allCategory.map((category) => CustomFilterChip(
              label: category,
              isSelected: selectedCategory == category,
              onSelected: (bool value) {
                setState(() => selectedCategory = category);
                applyCombinedFilters();
              },
            )).toList(),
          ),
        ),
 
        // 3. Using the new StockCard
        Expanded(
          child: ListView.builder(
            itemCount: displayStocks.length,
            itemBuilder: (context, index) {
              final stock = displayStocks[index];
              return StockCard(
                stock: stock,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockDetailPage(
                        symbol: stock.symbol,
                        name: stock.name,
                        price: stock.price,
                        change: stock.change,
                        priceHistory: stock.priceHistory,
                      ),
                    ),
                  );
                },
                onLikeToggle: () {
                  setState(() {
                    stock.like = !stock.like;
                    if (stock.like) {
                      if (!likedStock.contains(stock)) likedStock.add(stock);
                    } else {
                      likedStock.remove(stock);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}}