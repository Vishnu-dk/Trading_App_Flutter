
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_trade_window/models/portfolio_model.dart';
import 'package:flutter_trade_window/models/stock_model.dart';


 
// Master Data List
final List<Stock> allStocks = [
  Stock(symbol: "IREDA", name: "Indian Renewable Energy", price: 185.50, change: 4.2, sector: "Energy",priceHistory: [],like:false),
  Stock(symbol: "NHPC", name: "NHPC Limited", price: 92.30, change: 1.5, sector: "Energy",priceHistory: [],like:false),
  Stock(symbol: "HDFCBANK", name: "HDFC Bank Limited", price: 1450.00, change: -0.4, sector: "Banking",priceHistory: [],like:false),
  Stock(symbol: "ICICIBANK", name: "ICICI Bank", price: 1080.00, change: 0.2, sector: "Banking",priceHistory: [],like:false),
  Stock(symbol: "ZOMATO", name: "Zomato Limited", price: 158.20, change: -1.5, sector: "Tech",priceHistory: [],like:false),
  Stock(symbol: "INFY", name: "Infosys Limited", price: 1620.00, change: 1.1, sector: "Tech",priceHistory: [],like:false),
  Stock(symbol: "TATAMOTORS", name: "Tata Motors Ltd", price: 965.40, change: 2.1, sector: "AutoMobile",priceHistory: [],like:false),
];


List<Stock> likedStock=[];
final List<PortfolioStock> ownedStock=[];
List<Stock> displayStocks=[];


double tradeAccountBalance=0;
double investedAmount=0;
double currentAmount=0;


final List<String> allCategory =[
  "All","Energy","Banking","Tech","AutoMobile"
];
String selectedCategory="All";



final TextEditingController searchController=TextEditingController();
String currentSearchQuery="";

Timer?priceTimer;
final Random random=Random();