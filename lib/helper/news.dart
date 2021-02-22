import 'dart:convert';

import 'package:newsapp/models/article_model.dart';
import 'package:http/http.dart' as http;

class News{
  List<ArticleModel> news = [];

  Future<void> getNews() async{
    String url = 'http://newsapi.org/v2/top-headlines?country=in&apiKey=e4581f5e86a346188c52d8353de5c606';

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == 'ok'){
      jsonData['articles'].forEach((element){

        if(element['urlToImage']!=null && element['description']!=null){
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            content: element['context'],
          );
          
          news.add(articleModel);
          
        }

      });
    }
  }
}

class CategoryNewsClass{
  List<ArticleModel> news = [];

  Future<void> getCategoryNews(String category) async{
    String url = 'http://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=e4581f5e86a346188c52d8353de5c606';

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == 'ok'){
      jsonData['articles'].forEach((element){

        if(element['urlToImage']!=null && element['description']!=null){
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            content: element['context'],
          );

          news.add(articleModel);

        }

      });
    }
  }
}