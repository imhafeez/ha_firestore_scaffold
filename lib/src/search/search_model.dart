import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class SearchModel {
  Query? query;
  Query? localQuery;
  final int? limit;
  final String searchField;
  final _queryController = StreamController<String>();
  Sink<String> get searchKeywords => _queryController.sink;

  final StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();
  DocumentSnapshot? lastDocument;
  List<List<DocumentSnapshot>> documentPages = <List<DocumentSnapshot>>[];
  bool isRequesting = false;
  Stream<List<DocumentSnapshot>> get stream {
    return _streamController.stream;
  }

  SearchModel(
      {required this.query, required this.searchField, this.limit: 10}) {
    localQuery = this.query;
    _queryController.stream.listen((search) {
      lastDocument = null;
      documentPages.clear();
      if (search.isEmpty) _streamController.add([]);
      // if (search.length >= 3) {
      requestNextPage(search);
      // }
    });
  }
  void dispose() {
    _queryController.close();
    _streamController.close();
  }

  Query? buildQuery(String keywords) {
    if ((this.searchField).isNotEmpty)
      localQuery =
          query!.where(this.searchField, arrayContains: keywords.toLowerCase());

    localQuery = localQuery!.limit(limit!);

    if (lastDocument != null) {
      localQuery = localQuery!.startAfterDocument(lastDocument!);
    }
    ;
    return localQuery;
  }

  void requestNextPage(String keywords) {
    if (!isRequesting) {
      isRequesting = true;

      var currentRequestIndex = documentPages.length;

      buildQuery(keywords)!.snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var pageExists = currentRequestIndex < documentPages.length;

          if (pageExists) {
            documentPages[currentRequestIndex] = snapshot.docs;
          } else {
            documentPages.add(snapshot.docs);
          }

          var allPosts = documentPages.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          // #12: Broadcase all posts
          _streamController.add(allPosts);

          if (currentRequestIndex == documentPages.length - 1) {
            lastDocument = snapshot.docs.last;
          }

          isRequesting = false;
        } else {
          isRequesting = false;
          // if (snapshot.docChanges.length > 0) {
          _streamController.add([]);
          // }
        }
      });
      // subscribtionList.add(subscription);
    }
  }
}
