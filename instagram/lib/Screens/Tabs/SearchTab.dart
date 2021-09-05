import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:instagram/widgets/SearchUserListTile.dart';
import 'package:line_icons/line_icons.dart';


class Application {
  static final Algolia algolia = Algolia.init(
    applicationId: '3J4OQZYIY3',
    apiKey: 'ec04ee219adb5326f9f1c46e73ad8a76',
  );
}

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  AlgoliaQuery? algoliaQuery;

  List<AlgoliaObjectSnapshot> _results = [];
  void algo(String? val) async {
    Algolia algolia = Application.algolia;
    AlgoliaQuery query = algolia.instance.index('instagram_index').query(val!);

    AlgoliaQuerySnapshot snap = await query.getObjects();
    print('Hits count: ${snap.nbHits}');
    print(snap.hits);
    _results = snap.hits;
    setState(() {});
  }

  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    algo("sa");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: [
              Container(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    algo(value);
                  },
                  decoration: new InputDecoration(
                    prefixIcon: Icon(
                      LineIcons.search,
                      color: Colors.black,
                      size: 25,
                    ),
                    fillColor: Colors.grey[300],
                    filled: true,
                    hintText: "Search For other Users",
                    border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.black),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              _results.length == 0
                  ? Center(
                      child: Text('No Users Found'),
                    )
                  : Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Container();
                        },
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          if (_results[index].data['userID'] ==
                              '${FirebaseAuth.instance.currentUser!.uid}') {
                            return Container();
                          }
                          return SearchListTile(
                            name: _results[index].data['Name'],
                            username: _results[index].data['username'],
                            userID: _results[index].data['userID'],
                            photoUrl: _results[index].data['photoUrl'],
                          );
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
