

class Stock {
  final String symbol;
  final String name;
  double price;
  double change;
  final String sector;
  List<double> priceHistory;
  bool like;
 
  Stock({
    required this.symbol, 
    required this.name, 
    required this.price, 
    required this.change, 
    required this.sector,
    required this.priceHistory,
    required this.like,
  });
}