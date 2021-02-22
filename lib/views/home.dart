import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/helper/data.dart';
import 'package:newsapp/helper/news.dart';
import 'package:newsapp/models/article_model.dart';
import 'package:newsapp/models/category_model.dart';
import 'package:newsapp/views/article_view.dart';
import 'package:newsapp/views/category_news.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

List<ArticleModel> data = new List<ArticleModel>();
List<ArticleModel> articles = new List<ArticleModel>();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> category = new List<CategoryModel>();
  bool _loading = true;
  int currentMax = 0;
  final int increment = 10;
  bool isLoading = true;
//  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _loadMore();
    super.initState();
    category = getCategories();
    getNews();

//    _scrollController.addListener(() {
//      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
//        _loadMore();
//      }
//    });
  }

  Future _loadMore() async{

     setState(() {
       isLoading = true;
     });

     await new Future.delayed(const Duration(seconds: 2));
     for (var i = currentMax; i <= currentMax + increment; i++) {
      data.add(articles[i]);
     }

    setState(() {
      isLoading = false;
      currentMax = data.length;
    });

  }

  getNews() async{
    News news = News();
    await news.getNews();
    articles = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Latest'),
            Text('News',style: TextStyle(
              color: Colors.blue
            ),)
          ],
        ),
          elevation: 0.0,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) :
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[

              // Categories
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 70,
                child: ListView.builder(
                    itemCount: category.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return CategoryTile(
                        imageUrl: category[index].imageUrl,
                        categoryName: category[index].categoryName,
                      );
                    },
                )
              ),

              // Blogs
              LazyLoadScrollView(
                scrollOffset: 300,
                isLoading: isLoading,
                onEndOfPage: () => _loadMore(),
                    child: ListView.builder(
//                    controller: _scrollController,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context,index){
//                          if(index==data.length){
//                            return CupertinoActivityIndicator();
//                          }
                          return Item(index);
//                          return  BlogTile(
//                            imageUrl: data[index].urlToImage,
//                            title: data[index].title,
//                            desc: data[index].description,
//                            url: data[index].url,
//                          );
                        },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {

  final int index;

  const Item(
      this.index, {
        Key key,
        }
      ): super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: BlogTile(
            imageUrl: articles[index].urlToImage,
            title: articles[index].title,
            desc: articles[index].description,
            url: articles[index].url,
          ),
    );
  }
}

class CategoryTile extends StatelessWidget {

  final imageUrl, categoryName;
  CategoryTile({this.imageUrl,this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => CategoryNews(
            category: categoryName.toString().toLowerCase(),
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: imageUrl, width: 120,height: 60, fit: BoxFit.cover,
                )
            ),
            Container(
              alignment: Alignment.center,
            width: 120,height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black26,
              ),
              child: Text(categoryName,style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {

  final String imageUrl,title,desc,url;
  BlogTile({@required this.imageUrl,@required this.title, @required this.desc,@required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(
          builder: (context) => ArticleView(
            blogUrl: url,
          )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
                child: Image.network(imageUrl)
            ),
            Text(title,style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),),
            SizedBox(height: 8,),
            Text(desc,style: TextStyle(
            color: Colors.black54,
          ),)
          ],
        ),
      ),
    );
  }
}

