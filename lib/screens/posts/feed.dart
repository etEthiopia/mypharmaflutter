import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypharma/app_localizations.dart';
import 'package:mypharma/blocs/auth/bloc.dart';
import 'package:mypharma/blocs/news/bloc.dart';
import 'package:mypharma/components/appbars.dart';
import 'package:mypharma/components/article.dart';
import 'package:mypharma/components/drawers.dart';
import 'package:mypharma/components/loading.dart';
import 'package:mypharma/components/page_end.dart';
import 'package:mypharma/components/promotion.dart';
import 'package:mypharma/components/show_error.dart';
import 'package:mypharma/components/signinup.dart';
import 'package:mypharma/screens/front_splash.dart';
import 'package:mypharma/screens/posts/show_promo.dart';
import 'package:mypharma/services/services.dart';
import 'package:mypharma/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:mypharma/theme/font.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    final apiService = RepositoryProvider.of<APIService>(context);
    return Scaffold(
        appBar: cleanAppBar(
            title: AppLocalizations.of(context).translate("feed_screen_title")),
        drawer: UserDrawer(),
        backgroundColor: ThemeColor.background,
        body: BlocProvider<NewsBloc>(
            create: (context) => NewsBloc(apiService),

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
  int page = 1;
  int last = 1;
  ScrollController _controller;

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
  void initState() {
    final _feedBloc = BlocProvider.of<NewsBloc>(context);

    _feedBloc.add(NewsFetched(page: page));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _feedBloc = BlocProvider.of<NewsBloc>(context);

    _scrollListener() {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        setState(() {
          page = page + 1;
        });
        print("reach the bottom");
        _feedBloc.add(NewsFetched(page: page));
        // if (page <= last) {
        //   _feedBloc.add(NewsFetched(page: page));
        // }
      }
      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {
        print("reach the top");
      }
    }

    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      _paddingFix(true, 0);
    } else {
      _paddingFix(false, MediaQuery.of(context).size.width / 8);
    }
    return BlocListener<NewsBloc, NewsState>(listener: (context, state) {
      if (state is NewsFailure) {
        showError(state.error, context);
      }

      // ignore: missing_return
    }, child: BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
      if (state is NewsAllLoaded) {
        return PageEnd(context, 'feed');
      } else if (state is NewsLoading || state is NewsInital) {
        return LoadingLogin(context);
      } else if (state is NewsFailure) {
        if (state.error == 'Not Authorized') {
          return LoggedOutLoading(context);
        } else {
          return ErrorMessage(context, 'feed', state.error);
        }
      }
      if (state is NewsLoaded) {
        return Scaffold(
          backgroundColor: ThemeColor.background1,
          body: SafeArea(
              child: Container(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padd),
                    child: Material(
                      color: ThemeColor.background2,
                      child: Container(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.all(0)
                              : EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              page > 1
                                  ? Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            page = 1;
                                          });
                                          _feedBloc
                                              .add(NewsFetched(page: page));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.timer,
                                              color: ThemeColor.darkText,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Go back to the latest news",
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: ThemeColor.darkText,
                                                  fontSize: 20,
                                                  fontFamily: defaultFont),
                                            ),
                                          ],
                                        ),
                                      ))
                                  : SizedBox(
                                      height: 0,
                                    ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(bottom: 5, top: 10),
                                    color: Colors.grey[400],
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate("promo_title"),
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, bottom: 15),
                                height: 150,
                                color: Colors.grey[400],
                                child: GridView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.promos.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => ShowPromo(
                                                    id: state.promos[index].id,
                                                    title: state
                                                        .promos[index].title,
                                                    content: state.promos[index]
                                                        .description,
                                                    image: state
                                                        .promos[index].image,
                                                    author: state.promos[index]
                                                        .authorname)),
                                          );
                                        },
                                        child: promotion(
                                          context: context,
                                          id: state.promos[index].id,
                                          title: state.promos[index].title,
                                          description:
                                              state.promos[index].description,
                                          image: state.promos[index].image,
                                          profileimg:
                                              state.promos[index].profileimg,
                                          author: state.promos[index].author,
                                          authorname:
                                              state.promos[index].authorname,
                                        ));
                                  },
                                ),
                              ),
                              Expanded(
                                child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1),
                                    itemCount: state.newsList.length,
                                    controller: _controller,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      last = state.last;

                                      return article(
                                          title: state.newsList[index].title
                                              .toString(),
                                          image: state.newsList[index].image
                                              .toString(),
                                          content: state
                                              .newsList[index].description
                                              .toString(),
                                          time: state.newsList[index].date
                                              .toString(),
                                          category:
                                              state.newsList[index].category,
                                          context: context,
                                          id: state.newsList[index].id);
                                    }),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                SignInUp(),
              ],
            ),
          )),
        );
      }
    }));
  }
}
