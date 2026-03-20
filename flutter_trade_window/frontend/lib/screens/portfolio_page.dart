import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_trade_window/models/datas.dart';
import 'package:flutter_trade_window/widgets/stock_widgets.dart';



class PortfolioPage extends StatefulWidget {
  @override
  State<PortfolioPage> createState() => _PortfolioPage();
}
 
class _PortfolioPage extends State<PortfolioPage> {


  Timer? _refreshTimer;
 
  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        
      });
    });
  }
 
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  double get priceChange => currentAmount - investedAmount;
  
  bool get profit => priceChange >= 0;
 
  double get priceChangePercent {
    if (investedAmount == 0) return 0.0;
    return (priceChange / investedAmount) * 100;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Portfolio"),titleSpacing:32,backgroundColor: Color(0xFF1e3c72),titleTextStyle: TextStyle(color: Colors.white70, fontSize: 28, fontWeight: FontWeight.w400,letterSpacing:1.5),foregroundColor: Colors.white,),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children:[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 40, left: 25, right: 25),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Net Amount", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal)),
                    const SizedBox(height: 8),
                    Text("₹ ${profit ? '+ ' : ''}${priceChange.toStringAsFixed(2)}", style: TextStyle(
                          color: profit ? Colors.green : Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),),
                    Text("(${priceChangePercent.toStringAsFixed(2)}%)", style: TextStyle(
                          color: profit ? Colors.green.shade500 : Colors.red.shade700,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, 
                            backgroundColor:Colors.grey
                          ),
                          onPressed: () {
                            showAddBalance(context);
                          },
                          child: Row(
                            children: [
                              const Text("Add Balance"),
                              Icon(Icons.add)
                            ],
                          ) 
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black, 
                            backgroundColor:Colors.grey
                          ),
                          onPressed: () {
                            showWithdrawBalance(context);
                          },
                          child: Row(
                            children: [
                              const Text("Withdraw Balance"),
                              
                            ],
                          ) ,
                        ),
                      ],
                    )


                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Account Balance", style: const TextStyle(color: Colors.white, fontSize: 20, )),
                    Text("₹ ${tradeAccountBalance.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16,),),
                    const SizedBox(height: 8),
                    Text("Invested Amount", style: const TextStyle(color: Colors.white, fontSize: 20, )),
                    Text("₹ ${investedAmount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16, ),),
                    const SizedBox(height: 8),
                    Text("Current Amount", style: const TextStyle(color: Colors.white, fontSize: 20, )),
                    Text("₹ ${currentAmount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16, )),
                  ],
                ),
              ],
            ),
    
          ),
          Expanded(
            child: ListView.builder(
            itemCount: ownedStock.length,
            itemBuilder: (context, index) {
              final stock = ownedStock[index];
              return OwnedStockCard(
                stock: stock,
                onTap: (){
                        showSellSheet(context, stock);
                      }, 
              );
            },
          ),
          )
          
        ]
      )
    );
  }
}
 