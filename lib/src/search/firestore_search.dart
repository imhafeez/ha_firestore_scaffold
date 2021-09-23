part of ha_firestore_scaffold;

class HAFirestoreSearch extends SearchDelegate<String?> {
  Query? firestoreQuery;
  String searchField;
  int? limit;
  late SearchModel model;
  final Widget Function(BuildContext context, DocumentSnapshot snapshot)?
      builder;
  final Widget? emptyWidget;
  final Widget Function(dynamic)? header;
  String? groupBy;
  double Function(Orientation)? maxCrossAxisExtent;

  HAFirestoreSearch(
      {required this.firestoreQuery,
      required this.searchField,
      this.builder,
      this.limit,
      this.header,
      this.groupBy,
      this.emptyWidget,
      this.maxCrossAxisExtent}) {
    model = SearchModel(
        query: firestoreQuery, searchField: searchField, limit: limit);
  }
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: theme.primaryColor),
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isNotEmpty) {
            query = "";

            buildResults(context);
          } else {
            close(context, null);
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<DocumentSnapshot> allActivities = model.documentPages
        .fold<List<DocumentSnapshot>>(
            <DocumentSnapshot>[],
            (initialValue, pageItems) =>
                initialValue..addAll(pageItems)).toList();

    return resultList(context, allActivities);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    model.searchKeywords.add(query);
    return _buildSearchResults(context);
  }

  _buildSearchResults(BuildContext context) {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: model.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
          List<DocumentSnapshot> snapList = snapshot.data!;

          return resultList(context, snapList);
        } else {
          return emptyWidget ?? Container();
        }
      },
    );
  }

  dynamic resultList(BuildContext context, List<DocumentSnapshot> docs) {
    if (docs.isNotEmpty) {
      return HAListItemView(
        builder: builder,
        data: docs,
        groupByField: groupBy,
        header: header,
        maxCrossAxisExtent: maxCrossAxisExtent != null
            ? 300
            : maxCrossAxisExtent!(MediaQuery.of(context).orientation),
        style: ListViewStyle.auto,
      );

      // return ScreenTypeLayout(
      //   mobile: LazyLoadScrollView(
      //       onEndOfPage: () => model.requestNextPage(query),
      //       child: buildListView(docs, context)),
      //   tablet: LazyLoadScrollView(
      //       onEndOfPage: () => model.requestNextPage(query),
      //       child: buildWaterfallFlow(docs, context)),
      //   desktop: LazyLoadScrollView(
      //       onEndOfPage: () => model.requestNextPage(query),
      //       child: buildWaterfallFlow(docs, context)),
      // );
    } else {
      return emptyWidget ?? Container();
    }
  }

  // dynamic buildWaterfallFlow(
  //     List<DocumentSnapshot> listData, BuildContext context) {
  //   if ((this.groupBy ?? "").isNotEmpty && this.header != null) {
  //     Map<dynamic, List<DocumentSnapshot>> dataMap =
  //         collection.groupBy(listData, (snapshot) {
  //       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //       return data[this.groupBy!];
  //     });
  //     return ListView(
  //       children: dataMap.keys.map((e) {
  //         return StickyHeader(
  //           header: this.header!(e),
  //           content: WaterfallFlow(
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             // padding: this.scrollPadding,
  //             gridDelegate: SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
  //                 maxCrossAxisExtent: this.maxCrossAxisExtent != null
  //                     ? this.maxCrossAxisExtent!(
  //                         MediaQuery.of(context).orientation)
  //                     : 380,
  //                 mainAxisSpacing: 8),
  //             children: dataMap[e]!.map((e) {
  //               return this.builder!(context, e);
  //             }).toList(),
  //           ),
  //         );
  //       }).toList(),
  //     );
  //   } else {
  //     return WaterfallFlow(
  //       // padding: widget.scrollPadding,
  //       gridDelegate: SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
  //           maxCrossAxisExtent: this.maxCrossAxisExtent != null
  //               ? this.maxCrossAxisExtent!(MediaQuery.of(context).orientation)
  //               : 380,
  //           mainAxisSpacing: 8),
  //       children: listData.map((e) => this.builder!(context, e)).toList(),
  //     );
  //   }
  // }

  // ListView buildListView(
  //     List<DocumentSnapshot> listData, BuildContext context) {
  //   if ((this.groupBy ?? "").isNotEmpty && this.header != null) {
  //     Map<dynamic, List<DocumentSnapshot>> dataMap =
  //         collection.groupBy(listData, (snapshot) {
  //       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //       return data[this.groupBy!];
  //     });
  //     return ListView(
  //       children: dataMap.keys.map((e) {
  //         return StickyHeader(
  //           header: this.header!(e),
  //           content: ListView(
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             children: dataMap[e]!.map((e) {
  //               return this.builder!(context, e);
  //             }).toList(),
  //           ),
  //         );
  //       }).toList(),
  //     );
  //   } else {
  //     return ListView(
  //       // padding: widget.scrollPadding,
  //       children: listData.map((e) => this.builder!(context, e)).toList(),
  //     );
  //   }
  // }
}
