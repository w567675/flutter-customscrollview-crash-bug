import 'package:flutter/material.dart';
import 'dart:ui' as ui show PlaceholderAlignment;
import './widgets/iconfont/icon_font.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: PullToRefreshWidget(),
    );
  }
}

class PullToRefreshWidget extends StatefulWidget {
  @override
  State<PullToRefreshWidget> createState() => PullToRefreshState();
}

class PullToRefreshState extends State<PullToRefreshWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
      scrollController: _scrollController,
    );
  }
}

class RefreshWidget extends StatefulWidget {
  const RefreshWidget({required this.scrollController});

  final ScrollController scrollController;

  @override
  State<RefreshWidget> createState() => RefreshState();
}

class RefreshState extends State<RefreshWidget> {
  bool isRefreshing = false;
  bool isLoadingMore = false;
  late List data;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void bindItemData(List itemDatas) {
    setState(() {
      data.addAll(itemDatas);
      isLoadingMore = false;
      isRefreshing = false;
    });
  }

  void _updateScrollPosition() {
    final bool isBottom = widget.scrollController.position.pixels ==
        widget.scrollController.position.maxScrollExtent;
    if (!isLoadingMore && isBottom && !isRefreshing) {
      setState(() {
        isRefreshing = false;
        isLoadingMore = true;
        _loadMore();
      });
      _loadMore();
    }
  }

  List generateData() {
    return List.filled(20, 0, growable: true);
  }

  Future _loadMore() async {
    await Future.delayed(Duration(milliseconds: 300));
    bindItemData(generateData());
    return null;
  }

  List getDatas() {
    return List.filled(20, 0, growable: true);
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateScrollPosition);
    data = getDatas();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateScrollPosition);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: _buildListView(), onRefresh: _handlerRefresh);
  }

  Widget _buildListView() {
    return CustomScrollView(
      key: _refreshIndicatorKey,
      controller: widget.scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // if (index == data.length - 1) {
              //   return Column(
              //     children: [
              //       ListItem(),
              //       Container(
              //         alignment: Alignment.center,
              //         padding: EdgeInsets.all(5.0),
              //         child: Text('加载中...'),
              //       ),
              //     ],
              //   );
              // }
              return ListItem();
            },
            childCount: data.length,
          ),
        ),

        /// carash loading
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5.0),
            child: Text('loading...'),
          ),
        ),
      ],
    );
  }

  Future _handlerRefresh() async {
    if (!isLoadingMore) {
      setState(() {
        isRefreshing = true;
        isLoadingMore = false;
      });
      //模拟耗时3秒
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        data = generateData();
        isRefreshing = false;
        isLoadingMore = false;
      });
      widget.scrollController.jumpTo(0.0);
    }
    //widget.scrollController.animateTo(0.0, duration: new Duration(milliseconds:100), curve: Curves.linear);
    return null;
  }
}

class ListItem extends StatelessWidget {
  Widget _buildMoneyRow() {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Container(
            margin: EdgeInsets.only(right: 13),
            child: IconFont(
              IconNames.qian,
              size: 29,
            ),
          ),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '20000-20000',
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
                Container(
                  child: Text(
                    ' 元/月',
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(context) {
    return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Container(
              margin: EdgeInsets.only(right: 13),
              child: IconFont(
                IconNames.juli,
                size: 29,
              ),
            ),
            Expanded(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '阿斯顿那三电脑上的',
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    WidgetSpan(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          '600',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildTime() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Container(
          margin: EdgeInsets.only(right: 13),
          child: IconFont(
            IconNames.shizhong,
            size: 29,
          ),
        ),
        Expanded(
            child: Wrap(
          children: [
            Text(
              '实打实打算',
            ),
            Text(
              '实打实打算',
            ),
            Text(
              '实打实打算',
            ),
            Text(
              '实打实打算',
            ),
            Text(
              '实打实打算',
            ),
          ],
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 10,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 34),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://fornt-end.oss-cn-shanghai.aliyuncs.com/%E5%85%BC%E9%A5%BC%E6%9E%9C%E5%AD%90%E6%89%BE%E5%B7%A5%E4%BD%9C/%E6%9A%82%E6%97%A0%E5%B2%97%E4%BD%8D%E5%9B%BE%E7%89%87.png',
                        width: 220,
                        height: 140,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 37),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Row(
                              children: [
                                IconFont(
                                  IconNames.dingwei,
                                  size: 23,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 9,
                                  ),
                                  width: 339,
                                  child: Text(
                                    '不限',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 26,
                                    ),
                                  ),
                                )
                              ],
                            )),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '撒大苏打实打实',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  WidgetSpan(
                                    alignment: ui.PlaceholderAlignment.middle,
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      width: 1,
                                      height: 24,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'sdsdsdsd',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildMoneyRow(),
              _buildAddress(context),
              _buildTime(),
            ],
          ),
        ),
      ),
    );
  }
}
