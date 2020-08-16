import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/blocs/news/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/article.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/screens/front_splash.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthService>(context);
    return Scaffold(
        appBar: simpleAppBar(title: "Feed"),
        drawer: UserDrawer(),
        body: BlocProvider<NewsBloc>(
            create: (context) => NewsBloc(authService),

            //create: (context) => NewsBloc(_newsService),
            child: FeedList()));
  }
}

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  // void _fixProductsList() {
  //   newproductsList.add(moreProdcuts);
  // }

  double padd = 0;

  void _paddingFix(bool por, double size) {
    if (por) {
      setState(() {
        padd = 10;
      });
    } else {
      setState(() {
        padd = size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _feedBloc = BlocProvider.of<NewsBloc>(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      _paddingFix(true, 0);
    } else {
      _paddingFix(false, MediaQuery.of(context).size.width / 8);
    }
    print("about to");
    _feedBloc.add(NewsFetched());
    print("did");
    return BlocListener<NewsBloc, NewsState>(listener: (context, state) {
      if (state is NewsFailure) {
        showError(state.error, context);
      }
      // ignore: missing_return
    }, child: BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
      if (state is NewsLoading || state is NewsInital) {
        return LoadingLogin(context);
      }
      if (state is NewsLoaded) {
        return Container(
          color: Colors.grey[300],
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padd),
            child: Material(
              color: Colors.grey[100],
              child: Container(
                  padding: orientation == Orientation.portrait
                      ? EdgeInsets.all(0)
                      : EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                      itemCount: state.newsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.grey,
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Text("title: " +
                                  state.newsList[index].title.toString()),
                              Text("title: " +
                                  state.newsList[index].description.toString()),
                            ],
                          ),
                        );
                      })
                  // Text(state.newsList.length.toString())

                  // child: GridView.builder(
                  //   itemCount: feedList.length,
                  //   gridDelegate:
                  //       SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return article(
                  //       title: feedList[index]["title"],
                  //       image: feedList[index]["image"],
                  //       content: feedList[index]["content"],
                  //       time: feedList[index]["time"],
                  //     );
                  //   },
                  // ),
                  ),
            ),
          )),
        );
      }
    }));
  }
}
