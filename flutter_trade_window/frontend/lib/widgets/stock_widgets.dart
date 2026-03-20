
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_trade_window/models/datas.dart';
import 'package:flutter_trade_window/models/portfolio_model.dart';
import 'package:flutter_trade_window/models/stock_model.dart';
import 'package:flutter_trade_window/screens/portfolio_page.dart';
import 'package:flutter_trade_window/screens/wishlist_page.dart';
import 'package:flutter_trade_window/services/api_services.dart';

class StockCard extends StatelessWidget {
  final Stock stock;
  final VoidCallback onLikeToggle;
  final VoidCallback onTap;
 
  const StockCard({
    super.key,
    required this.stock,
    required this.onLikeToggle,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    bool isPositive = stock.change >= 0;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(stock.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₹${stock.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${isPositive ? '+ ' : ''}${stock.change.toStringAsFixed(2)}%",
                        style: TextStyle(
                          color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(stock.like ? Icons.favorite : Icons.favorite_border),
                  color: Colors.red,
                  onPressed: ()async{
                    await ApiService.toggleWishlist(stock.symbol);
                    onLikeToggle();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OwnedStockCard extends StatelessWidget {
  final PortfolioStock stock;
    final VoidCallback onTap;

 
  const OwnedStockCard({
    super.key,
    required this.stock,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    
    bool isPositive = stock.netChange >= 0;
    return InkWell(
      onTap:onTap,
      child: Container( 
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(stock.stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 4),
                      Text("(${stock.stock.name})", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),                 
                  Text("Quantity : ${stock.quantity}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),
                  Text("Average Price : ${stock.avgPrice.toStringAsFixed(2)}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),
                  Text("Invested : ${(stock.avgPrice*stock.quantity).toStringAsFixed(2)}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),
                  Text("Current : ${(stock.stock.price*stock.quantity).toStringAsFixed(2)}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),


                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("₹${stock.stock.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPositive ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:Column(
                        children: [
                          Text(
                            "${isPositive ? '+ ' : ''}${stock.netChange.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "(${isPositive ? '+ ' : ''}${stock.percentageChange.toStringAsFixed(2)}%)",
                            style: TextStyle(
                              color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ) 
                      
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;
 
  const CustomFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        selectedColor: Colors.blue.shade800,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}

class CustomHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? actionButton;
 
  const CustomHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionButton,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 40, left: 25, right: 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: const Color.fromARGB(255, 1, 26, 170)
                ),
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => WishListPage())
                ),
                child: const Text("Wishlist"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: const Color.fromARGB(255, 1, 26, 170)
                ),
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => PortfolioPage())
                ),
                child: const Text("Portfolio"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class StockUtils {
  double totalCurrentAmount(){
    double amount=0;
    for(var items in ownedStock){
      amount+=(items.stock.price*items.quantity);
    }
    return amount;
  }
  
  static List<Stock> filterStocks({
    required List<Stock> allStocks,
    required String category,
    required String query,
  }) {
    return allStocks.where((stock) {
      bool matchCategory = (category == "All" || stock.sector == category);
      bool matchSearch = stock.symbol.toLowerCase().contains(query.toLowerCase()) ||
          stock.name.toLowerCase().contains(query.toLowerCase());
 
      return matchCategory && matchSearch;
    }).toList();
  }
}
 
void showAddBalance(BuildContext context) {
  double localBalance = 0;

  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
    
      TextEditingController balanceController = TextEditingController();
  
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add Balance", 
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Amount", 
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                    SizedBox(
                      width: 150, 
                      child: TextField(
                        controller: balanceController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "0",
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        onChanged: (value) {
                          setSheetState(() {
                            localBalance = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),                
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Payable", 
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                    Text("₹$localBalance", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1e3c72),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: localBalance > 0 ? () async {

                    
                    double? updatedBalance = await ApiService.addBalance(localBalance);
                    
                  
                    if (updatedBalance != null) {
                      setSheetState(() {
                        tradeAccountBalance = updatedBalance;
                      });
                      
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Successfully Added "),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 1),
                        )
                      );
                    } else {
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Server Error: Money not added"),
                          backgroundColor: Colors.red,
                        )
                      );
                    }
                  } : null, 
                  child:   Text(localBalance > 0 ? "Add Now" : "Add Amount", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showWithdrawBalance(BuildContext context) {
  double localWithdrawBalance = 0;

  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
    
      TextEditingController balanceController = TextEditingController();
  
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Withdraw Balance", 
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Amount", 
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                    SizedBox(
                      width: 150, 
                      child: TextField(
                        controller: balanceController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "0",
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        onChanged: (value) {
                          setSheetState(() {
                            localWithdrawBalance = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),                
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Payable", 
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                    Text("₹$localWithdrawBalance", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue)),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1e3c72),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: tradeAccountBalance>localWithdrawBalance ? () async {

                    
                    double? updatedBalance = await ApiService.withdrawBalance(localWithdrawBalance);
                    

                    if (updatedBalance != null) {
                      setSheetState(() {
                        tradeAccountBalance = updatedBalance;
                      });
                      
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Successfully Withdrawed"),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 1),
                        )
                      );
                    } else {
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Server Error: Money not WithDrawed"),
                          backgroundColor: Colors.red,
                        )
                      );
                    }
                  } : null, 
                  child:  Text(tradeAccountBalance>localWithdrawBalance?"Withdraw Now":"Insufficient", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showSellSheet(BuildContext context,PortfolioStock stock){
  int localquantity=1;
  Timer?popupTimer;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.vertical(
        top: Radius.circular(25)
      )
    ), 
    builder: (context){
      return StatefulBuilder(
        builder: ( context, setSheetState){
          popupTimer??Timer.periodic( Duration(seconds: 1), (timer){
            if(context.mounted){
              setSheetState((){

              });
            }
          });
          double cost=localquantity*stock.stock.price;
          return Padding(
            padding: const EdgeInsetsGeometry.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Confirm Sell",style: TextStyle(color: Colors.grey.shade600,fontSize: 16)),
                const SizedBox(height: 8,),
                Text("${stock.stock.symbol}-${stock.stock.name}",style: TextStyle(color: Colors.grey.shade600,fontSize: 20,fontWeight: FontWeight.bold)),
                const Divider(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Quantity",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius:BorderRadius.circular(12), 
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              if(localquantity>1){
                                setSheetState(()=>
                                  localquantity--
                                );
                              }
                            }, 
                            icon: Icon(Icons.remove_circle_outline)),
                          Text("$localquantity",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                          IconButton(
                            onPressed: (){
                              if(localquantity<stock.quantity){
                                setSheetState(()=>
                                  localquantity++
                                );
                              }
                              
                            }, 
                            icon: Icon(Icons.add_circle_outline)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            children: [
                              Text("Total Amount",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,color: Colors.blue)),
                              Text("₹${cost.toStringAsFixed(2)}",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,color: Colors.black)),

                              const SizedBox(height: 30,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1e3c72),
                                  minimumSize:const Size(150,55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )
                                ),
                                onPressed: localquantity<=stock.quantity?()async{
                                  bool success=await ApiService.sellTradeStock(stock.stock.symbol, localquantity, stock.stock.price);
                                  if(success){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:Text("Successfully Sold"),
                                      backgroundColor: Colors.green.shade800,)
                                  );
                                  }
                                }:null, 
                                child: Text(localquantity<=stock.quantity?"Sell Now":"Insufficient Stock",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18,color: Colors.white)))


                            ],
                        )

                        ],
                    )
                    ,
                    )
                  ]
                )
              ],
            ),
          );
        }
      );

    // ignore: dead_code
    }).then((value)=>popupTimer?.cancel());
}

void executeSell(PortfolioStock stock,int quantity){
  double avgcost=quantity*stock.avgPrice;
  investedAmount-=avgcost;
  int index=ownedStock.indexWhere((item)=>item.stock.symbol==stock.stock.symbol);
  if(stock.quantity>quantity){
    
    ownedStock[index].quantity-=quantity;
  }else{
    
    ownedStock.removeAt(index);
  }
  double total=0;
  for(var item in ownedStock){
    total+=item.quantity*item.stock.price;
  }
  currentAmount=total;
  
  double sellcost=quantity*stock.stock.price;
  tradeAccountBalance+=sellcost;
  
}

void showBuySheet(BuildContext context,Stock stock){
  Timer?popupTimer;
  int localquantity=1;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.vertical(
        top: Radius.circular(25)
      )
    ), 
    builder: (context){
      return StatefulBuilder(
        builder: (BuildContext context,StateSetter setSheetState){
          popupTimer??Timer.periodic(Duration(seconds: 1), (timer){
            if(context.mounted){
              setSheetState((){
              });
            }
          });
          double cost=localquantity*stock.price;
          return Padding(
            padding: const EdgeInsetsGeometry.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Confirm Purchase",style: TextStyle(color: Colors.grey.shade600,fontSize: 16)),
                const SizedBox(height: 8,),
                Text("${stock.symbol}-${stock.name}",style: TextStyle(color: Colors.grey.shade600,fontSize: 20,fontWeight: FontWeight.bold)),
                const Divider(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Quantity",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius:BorderRadius.circular(12), 
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              if(localquantity>1){
                                setSheetState(()=>
                                  localquantity--
                                );
                              }
                            }, 
                            icon: Icon(Icons.remove_circle_outline)),
                          Text("$localquantity",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                          IconButton(
                            onPressed: (){
                              setSheetState(()=>
                                  localquantity++
                                );
                            }, 
                            icon: Icon(Icons.add_circle_outline)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            children: [
                              Text("Total Payable",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,color: Colors.blue)),
                              Text("₹$cost",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,color: Colors.black)),

                              const SizedBox(height: 30,),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1e3c72),
                                  minimumSize:const Size(150,55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )
                                ),
                                onPressed: tradeAccountBalance>=cost?()async{
                                  bool success=await ApiService.buyTradeStock(stock.symbol, localquantity , stock.price);
                                  if(success){
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:Text("Successfully Purchased"),
                                      backgroundColor: Colors.green,)
                                  );

                                  }
                                  
                                }:null, 
                                child: Text(tradeAccountBalance>=cost?"Buy Now":"Insufficient Balance",style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18,color: Colors.white)))


                            ],
                        )

                        ],
                    )
                    ,
                    )
                  ]
                )
              ],
            ),
          );
        }
      );

    // ignore: dead_code
    }).then((value)=>popupTimer?.cancel());
}

