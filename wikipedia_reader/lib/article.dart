import 'package:flutter/material.dart';
import 'summary.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';


class ArticleModal{
  Future<Summary> getRandomArticleSummary() async{

    final uri=Uri.https(
      'en.wikipedia.org',
      '/api/rest_v1/page/random/summary',  
    );
    final response=await get(uri);

    if(response.statusCode!=200){
      throw HttpException("Failed To Load Resource");
    }
    return Summary.fromJson(jsonDecode(response.body));

  }
}



class ArticleViewModal extends ChangeNotifier{
  final ArticleModal model;
  Summary?summary;
  String? errorMessage;
  bool loading=false;

  ArticleViewModal(this.model){
    getRandomArticleSummary();
  }

  Future <void> getRandomArticleSummary() async {
    loading=true;
    notifyListeners();


    try{
      summary = await model.getRandomArticleSummary();

      print('Article loaded: ${summary!.titles.normalized}');
      errorMessage=null;
    } on HttpException catch (error){
      errorMessage=error.message;
      print('Error loading article: ${error.message}'); 
      summary=null;
    }
    loading=false;
    notifyListeners();
  }
}

class ArticleView extends StatelessWidget{
  ArticleView({super.key});

  final viewModal=ArticleViewModal(ArticleModal());

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wikipedia Flutter"),
      ),
      body: ListenableBuilder(
        listenable: viewModal,
        builder: (context,child){
          return switch((
            viewModal.loading,
            viewModal.summary,
            viewModal.errorMessage,
          )){
            (true,_,_)=>CircularProgressIndicator(),
            (false,_,String message)=>Center(child: (Text(message))),
            (false,null,null)=>Center(
              child:Text("An Unknown error Taken")
            ),
            (false,Summary summary,null)=>ArticlePage(
              summary:summary,
              nextArticleCallback:viewModal.getRandomArticleSummary,
            )
          };
          }
      ),
    );
    
  }
}

class ArticlePage extends StatelessWidget{
  const ArticlePage({
    super.key,
    required this.summary,
    required this.nextArticleCallback

  });
  final Summary summary;
  final VoidCallback nextArticleCallback;

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        children: [
          ArticleWidget(summary:summary),
          ElevatedButton(onPressed: nextArticleCallback, child: Text("Next Random Article")),
        ],
      ),
    ) ;
  }
}

class ArticleWidget extends StatelessWidget{
  const ArticleWidget({super.key,required this.summary});

  final Summary summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:Column(
        
        spacing: 10.0,
        
        children: [
          if (summary.hasImage)
          Image.network(
            
            summary.originalImage!.source,
          ),
          Text(
            summary.titles.normalized,
            overflow: TextOverflow.ellipsis,
            style: TextTheme.of(context).displaySmall,

          ),
          if (summary.description!=null)
            Text(
              summary.description!,
              overflow: TextOverflow.ellipsis,
              style: TextTheme.of(context).bodySmall,

            ),
            Text(
              summary.extract,
            )
        ],)
      );
      
  }
}



