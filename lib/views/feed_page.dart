import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/post.dart';
import '../services/network.dart';
import '../widgets/options_bar.dart';
import '../widgets/feed_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  ConnectivityResult _connectionResult = ConnectivityResult.none;

  List<Post> posts = [];
  bool _isInitialLoad = true;
  bool _isLoading = true;
  bool _reachedEnd = false;
  bool _noConnection = false;

  String sortOrder = 'Recent';

  final _scrollController = ScrollController();
  final network = Network();

  void getPosts() async {
    _connectionResult = await Connectivity().checkConnectivity();

    if (_connectionResult == ConnectivityResult.none) {
      setState(() {
        _noConnection = true;
      });
      showCustomSnack(
        context,
        'No internet connection.\nPlease try again later...',
        const Icon(
          Icons.warning_amber,
          color: Colors.red,
        ),
      );
      return;
    } else {
      setState(() {
        _noConnection = false;
      });
    }

    if (_reachedEnd) {
      showCustomSnack(
        context,
        'No more posts to load!',
        const Icon(
          Icons.warning_amber,
          color: Colors.yellow,
        ),
      );
      return;
    }

    final newPosts = await network.fetchPosts(sortOrder);

    setState(() {
      var newList = [...newPosts.toList()];

      if (newList.isEmpty) {
        _reachedEnd = true;

        showCustomSnack(
          context,
          'No more posts to load!',
          const Icon(
            Icons.warning_amber,
            color: Colors.yellow,
          ),
        );
      }

      posts.addAll(newList);
      _isLoading = false;
      _isInitialLoad = false;
    });
  }

  void setSortOrder(newValue) {
    sortOrder = newValue;

    // Prepare list to get new data
    posts = [];

    getPosts();
  }

  @override
  void initState() {
    super.initState();

    getPosts();

    _scrollController.addListener(() {
      if ((_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent) &&
          !_isInitialLoad &&
          !_isLoading) {
        _isLoading = true;
        getPosts();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Feed')),
      body: Column(
        children: [
          OptionsBar(setSortOrder),
          Expanded(
            child: _noConnection
                ? SizedBox(
                    width: 500,
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("You're offline"),
                        const SizedBox(height: 30),
                        OutlinedButton(
                          onPressed: () {
                            getPosts();
                          },
                          child: const Text('Reconnect'),
                        )
                      ],
                    ),
                  )
                : _isInitialLoad
                    ? const Center(child: Text('Loading...'))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: posts.length,
                        itemBuilder: (BuildContext ctx, int i) {
                          return FeedCard(
                            key: Key(posts[i].id.toString()),
                            post: posts[i],
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}

void showCustomSnack(BuildContext context, String text, Icon icon) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(
      children: [
        Flexible(flex: 1, fit: FlexFit.tight, child: icon),
        Flexible(
          flex: 4,
          child: Text(text, overflow: TextOverflow.ellipsis),
        ),
      ],
    ),
  ));
}
