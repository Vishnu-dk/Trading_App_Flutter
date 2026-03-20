import 'package:flutter_trade_window/models/stock_model.dart';

class PortfolioStock {
  final Stock stock;
  int quantity;
  double avgPrice;
 
  PortfolioStock({
    required this.stock,
    this.quantity = 0,
    this.avgPrice = 0,
  });
 
  double get totalInvested => quantity * avgPrice;

  double get currentMarketValue => quantity * stock.price;

  double get netChange => currentMarketValue - totalInvested;
  
  double get percentageChange => totalInvested == 0
      ? 0.0
      : (netChange / totalInvested) * 100;
}