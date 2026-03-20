import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_trade_window/models/datas.dart';
import 'package:flutter_trade_window/models/stock_model.dart';
import 'package:flutter_trade_window/widgets/stock_widgets.dart';



class StockDetailPage extends StatefulWidget{
  final String symbol;
  final String name;
  final double price;
  final double change;
  final List<double> priceHistory;

  const StockDetailPage({
    super.key,
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.priceHistory,
  });

  @override
  State<StockDetailPage> createState() =>_StockDetailPage();
}

class _StockDetailPage extends State<StockDetailPage>{


  Timer?_updateTimer;

  @override
  void initState() {

    super.initState();
    _updateTimer=Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
      });
    });
  }



  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void buyStock(int quantity,double marketPrice,Stock stock){

  }

  @override
  Widget build(BuildContext context) {

    final currentstocks=allStocks.firstWhere((s)=>s.symbol==widget.symbol);
    bool isPostive=currentstocks.change>=0;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentstocks.symbol),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              Text("LIVE MARKET DATA", style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
              Text(currentstocks.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Text("₹${currentstocks.price.toStringAsFixed(2)}",style: const TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
              Text("${isPostive?'+':''} ${currentstocks.change.toStringAsFixed(2)}%" ,style: TextStyle(color: isPostive?Colors.green:Colors.red),),

              const SizedBox(height: 60,),
              Container(
                height: 500,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20), // Space above/below the chart
                decoration: BoxDecoration(
                  color: Colors.white, // White looks cleaner for charts
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade200), // Subtle border instead of solid grey
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: StockChart(isPositive: isPostive,history: currentstocks.priceHistory,),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        showBuySheet(context, currentstocks);
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white
                      ),
                      child: Text("Buy")
                      )
                    )
                ],
              ),
              const SizedBox(height: 20,)
            ],  
          ),  
        ),
    );  
  }
}
 


class StockChart extends StatelessWidget{
  final bool isPositive;
  final List<double> history;
  const StockChart({
    super.key,
    required this.isPositive,
    required this.history});

 @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 10,right: 50,top: 20,bottom: 20),
      child: CustomPaint(
        painter: ChartPainter(isPositive:isPositive,history:history ),
      ),
    );
  }
}


class ChartPainter extends CustomPainter{
  final List<double> history;
  final bool isPositive;
  ChartPainter ({required this.isPositive,required this.history});


  void _drawPriceLabel(Canvas canvas,Size size,double price,double yPos){
    final textPainter=TextPainter(
      text: TextSpan(
        text: "₹${price.toStringAsFixed(1)}",
        
        style: TextStyle(
          color:Colors.grey.shade900,
          fontSize: 10
        ),  
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width-45, yPos-6));
  }

@override
void paint(Canvas canvas, Size size) {
  // 1. Define the "Pen" (Paint object)
  var paint = Paint()
    ..color = isPositive ? Colors.green : Colors.red // Set color based on status
    ..style = PaintingStyle.stroke                  // We want a line, not a filled shape
    ..strokeWidth = 3.0                             // Thickness of the line
    ..strokeCap = StrokeCap.round;                  // Smooth edges at the ends
  
  var gridPaint=Paint()
    ..color=Colors.grey
    ..strokeWidth=1;

  var path = Path();

  

  double minPrice=history.reduce(min);
  double maxPrice=history.reduce(max);

  double range=maxPrice-minPrice;

  if(range==0){
    range=1;
  }

 

  int divisions = 10;
  double yStep = size.height / (divisions - 1);
  double priceStep = range / (divisions - 1);
   
  for (int i = 0; i < divisions; i++) {
    double currentLabelPrice = minPrice + (i * priceStep);
    double yPos = size.height - (i * yStep);
   
    _drawPriceLabel(canvas, size, currentLabelPrice, yPos);
    
    canvas.drawLine(
      Offset(0, yPos),
      Offset(size.width - 70, yPos),
      gridPaint..color = Colors.grey.withOpacity(0.1)
      
    );
  }

    
  // We also constrain the graph width so it doesn't overlap the labels
  double chartWidth = size.width - 60;
  double xInterval = chartWidth / (history.length - 1);
 
  for (int i = 0; i < history.length; i++) {
    double y = size.height - ((history[i] - minPrice) / range * size.height);
    double x = i * xInterval;
 
    if (i == 0) {
      path.moveTo(x, y);
    }
    else {
      path.lineTo(x, y);
    }
  }


  double latestPrice=history.last;
  double latestY=size.height-((latestPrice-minPrice)/range*size.height);

  var bublepoint=Paint()
    ..color=isPositive?Colors.green:Colors.red;
  Rect bubleRect = Rect.fromCenter(
    center: Offset(size.width-25, latestY), 
    width: 50, 
    height: 20);

  canvas.drawRRect(RRect.fromRectAndRadius(bubleRect, Radius.circular(5)), bublepoint);
  final textPainter=TextPainter(
    text: TextSpan(
      text: latestPrice.toStringAsFixed(1),
      style: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      )
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(canvas, Offset(size.width-45, latestY-6));

 
  canvas.drawPath(path, paint);
}
  @override
  bool shouldRepaint(CustomPainter oldDelegate)=>true;
}