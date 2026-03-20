import 'dart:convert';
import 'package:flutter_trade_window/models/datas.dart';
import 'package:flutter_trade_window/models/portfolio_model.dart';
import 'package:flutter_trade_window/models/stock_model.dart';
import 'package:http/http.dart' as http;

 
class ApiService {

  static const String baseUrl = "http://localhost:8000"; 

 
  static Future<double> fetchBalance() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/trade_acccount_balance?username=Vishnu'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double balance= data["trade_account_balance"];
        return balance;
      }
    } catch (e) {
      print("Error: $e");
    }
    return 0.0; 
  }

  static Future<double?> addBalance(double amount) async{
    try{
      final response=await http.post(Uri.parse('http://localhost:8000/user/deposit?username=Vishnu&amount=$amount'));

      if(response.statusCode==200){
        final data=json.decode(response.body);
        return (data["new_balance"] as num).toDouble();
      }
      else{
        print("Failed to add balance $amount");
        
      }
    }
    catch(e){
      print("error in server $e");
    }
    return null;

  }

  static Future<double?>withdrawBalance(double amount) async{
    try{
      final response= await http.post(Uri.parse('http://localhost:8000/user/withdraw?username=Vishnu&amount=$amount'));
      if(response.statusCode==200){
        final data=json.decode(response.body);
        return(data["new_balance"]as num).toDouble();
      }
      else{
        print("Failed to withdraw $amount");
      }
    }
    catch(e){
      print("Failed server $e");
    }
  return null;
  }

  static Future<bool> buyTradeStock(String symbol,int quantity,double price) async{
    try{
      final response = await http.post(Uri.parse("http://localhost:8000/user/buy"),
                    headers: {"Content-Type": "application/json"},
                    body: json.encode({
                      "username":"Vishnu",
                      "symbol":symbol,
                      "quantity":quantity,
                      "price":price
                    }));


      if(response.statusCode==200){
        return true;
      }
      else{
        print("Buy Failed ${response.body}");
        return false;
      }
    }
    catch(e){
      print("Server Error $e");
      return false;
    }
  }
  static Future<bool> sellTradeStock(String symbol,int quantity,double price) async{
    try{
      final response = await http.post(Uri.parse("http://localhost:8000/user/sell"),
                    headers: {"Content-Type": "application/json"},
                    body: json.encode({
                      "username":"Vishnu",
                      "symbol":symbol,
                      "quantity":quantity,
                      "price":price
                    }));


      if(response.statusCode==200){
        return true;
      }
      else{
        print("Buy Failed ${response.body}");
        return false;
      }
    }
    catch(e){
      print("Server Error $e");
      return false;
    }
  }


  static Future<void> syncPortfolio() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8000/user/portfolio?username=Vishnu'));
  
      if (response.statusCode == 200) {
        List<dynamic> rawData = json.decode(response.body);
        print("Portfolio Data: $rawData");
  
        ownedStock.clear();
        for (var item in rawData) {
          Stock matchingStock = allStocks.firstWhere(
            (s) => s.symbol == item['symbol'],
            orElse: () => Stock(
              symbol: item['symbol'], 
              name: "Unknown", 
              price: 0, 
              change: 0, 
              sector: "", 
              priceHistory: [], 
              like: false
            ),
          );
  
          // 3. Add to the ownedStock list
          ownedStock.add(PortfolioStock(
            stock: matchingStock,
            quantity: item['quantity'],
            avgPrice: (item['avg_price'] as num).toDouble(),
          ));
        }
      }
    } catch (e) {
      print("Portfolio Sync Error: $e");
    }
  }
 
  static Future<void> toggleWishlist(String symbol) async{
    await http.post(Uri.parse('$baseUrl/user/wishlist/toggle'),
                    headers: {"Content-Type": "application/json"},
                    body: json.encode({
                      "symbol":symbol,
                    }));
  }

  static Future<List<String>> fetchWishList()async{
    final response=await http.get(Uri.parse("/user/wishlist"));
    if(response.statusCode==200){
      return List<String>.from(json.decode(response.body));
    }
    return [];
  }
  
}
 
 