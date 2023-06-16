import 'package:flutter/material.dart';

import '../../helper/size_helpers.dart';
import '../../utils/constants.dart';
import '../../utils/style.dart';

class HomePage extends StatefulWidget {
  final bool isLogin;

  const HomePage({super.key, required this.isLogin});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _getBodyLayout(context),
        bottomNavigationBar: _getBottomBarLayout(context),
      ),
    );
  }

  _getBodyLayout(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: displayHeight(context) * .35,
            floating: true,
            pinned: true,
            snap: true,
            actionsIconTheme: const IconThemeData(opacity: 0.0),
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
      body: Center(child: _getListViewLayout(context)),
    );
  }

  _getListViewLayout(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _horizontalList(10, context);
      },
    );
  }

  Widget _horizontalList(int n, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Now Playing",
                    style: headingStyle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "See all >",
                        style: textFieldStyle,
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: displayHeight(context) * .4,
            width: displayWidth(context),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                n,
                    (i) => _getMovieItemContainer(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getMovieItemContainer(BuildContext context) {
    return SizedBox(
      width: 200,
      height: displayHeight(context) * .3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: displayHeight(context) * .3,
            child: Card(
              semanticContainer: true,
              margin: const EdgeInsets.all(10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: const SizedBox(
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Film Name",
                style: filmNameTextStyle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "1h 37m",
                  style: signInDesStyle,
                ),
                SizedBox(
                  width: displayWidth(context) * .15,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                  size: 18,
                ),
                const Text(
                  "9.5",
                  style: signInDesStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getBottomBarLayout(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: "Home",
          activeIcon: Icon(
            Icons.home,
          ),
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
          ),
          label: "Search",
          activeIcon: Icon(
            Icons.search,
          ),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.star, color: Colors.grey),
          label: "Activity",
          activeIcon: Icon(
            Icons.search,
          ),
        ),
        widget.isLogin
            ? const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
          activeIcon: Icon(
            Icons.search,
          ),
        )
            : const BottomNavigationBarItem(
            icon: Icon(Icons.login), label: ""),
      ],
    );
  }
}
