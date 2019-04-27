import 'package:flutter/material.dart';
import 'package:flutter_news2/newsapi.dart';
import 'package:flutter_news2/notice.dart';

class NoticeList extends StatefulWidget {
  final state = new _NoticeListPageState();

  @override
  _NoticeListPageState createState() => state;
}

class _NoticeListPageState extends State<NoticeList> {
  List _categories = List();
  var _CategorySelected = 0;

  List _news = List();
  var repository = new NewsApi();
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            _getListCategory(),
            Expanded(
              child: _getListViewWidget(),
            )
          ],
        ),
      ),
      bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  @override
  void initState() {
    setCategories();
    loadNotices();
  }

  Widget _getBottomNavigationBar() {
    return BottomNavigationBar(
      onTap: onTabTapped,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.shifting,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          title: Text("Recentes"),
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.list),
          title: Text("Notícias"),
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
            icon: const Icon(Icons.info),
            title: Text("Sobre"),
            backgroundColor: Colors.red),
      ],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getListViewWidget() {
    var list = new ListView.builder(
      itemCount: _news.length,
      padding: EdgeInsets.only(top: 5.0),
      itemBuilder: (context, index) {
        return _news[index];
      },
    );

    return list;
  }

  loadNotices() async {
    List result = await repository.loadNews();

    setState(() {
      result.forEach((item) {
        var notice = new Notice(
            item['url_img'], item['tittle'], item['date'], item['description']);
        _news.add(notice);
      });
    });
  }

  void setCategories() {
    _categories.add("Geral");
    _categories.add("Esporte");
    _categories.add("Tecnologia");
    _categories.add("Entretenimento");
    _categories.add("Saúde");
    _categories.add("Negócios");
  }

  Widget _getListCategory() {
    ListView listCategory = ListView.builder(
      itemCount: _categories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return _buidCategoryItem(index);
      },
    );

    return new Container(
      height: 55.0,
      child: listCategory,
    );
  }

  Widget _buidCategoryItem(index) {
    return new GestureDetector(
      onTap: () {
        onTabCategory(index);
      },
      child: Center(
          child: Container(
        margin: EdgeInsets.only(left: 10.0),
        child: Material(
          elevation: 2.0,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          child: Container(
            padding:
                EdgeInsets.only(left: 12.0, top: 7.0, bottom: 7.0, right: 12.0),
            color: _CategorySelected == index
                ? Colors.blue[800]
                : Colors.blue[500],
            child: Text(
              _categories[index],
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      )),
    );
  }

  onTabCategory(index) {
    setState(() {
      _CategorySelected = index;
    });
  }
}
