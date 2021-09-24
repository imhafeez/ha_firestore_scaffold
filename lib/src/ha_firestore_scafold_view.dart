part of ha_firestore_scaffold;

class HAFirestoreScaffold extends StatefulWidget {
  final String? title;
  final Query? query;
  final int Function(DeviceScreenType)? limit;
  final Widget Function(BuildContext context, DocumentSnapshot snapshot)?
      itembuilder;
  final Widget Function(dynamic)? header;
  final Widget? emptyWidget;
  final SearchDelegate<String?>? searchDelegate;
  final String? groupBy;
  final Widget? floatingAction;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final List<Widget>? actions;
  final double Function(Orientation)? maxCrossAxisExtent;
  final EdgeInsets scrollPadding;
  final Widget? leading;
  final Widget? endDrawer;
  const HAFirestoreScaffold(
      {Key? key,
      this.title,
      this.query,
      this.limit,
      this.itembuilder,
      this.header,
      this.groupBy,
      this.emptyWidget,
      this.searchDelegate,
      this.floatingAction,
      this.floatingActionButtonLocation,
      this.actions,
      this.leading,
      this.maxCrossAxisExtent,
      this.endDrawer,
      this.scrollPadding = EdgeInsets.zero})
      : super(key: key);

  @override
  _HAFirestoreScaffoldState createState() => _HAFirestoreScaffoldState();
}

class _HAFirestoreScaffoldState extends State<HAFirestoreScaffold> {
  GlobalKey<ScaffoldState> scafoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scafoldKey,
        appBar: AppBar(
          leading: widget.leading ?? const BackButton(),
          title: Text(widget.title ?? ""),
          actions: [
            if (widget.searchDelegate != null)
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context, delegate: widget.searchDelegate!);
                  }),
            if (widget.actions != null) ...widget.actions!
          ],
        ),
        floatingActionButton: widget.floatingAction,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        endDrawer: widget.endDrawer,
        body: HAFirestoreRealtimePaginatedView(
          key: ObjectKey(widget.query),
          query: widget.query,
          limit: widget.limit == null
              ? 50
              : widget.limit!(getDeviceType(MediaQuery.of(context))),
          builder: widget.itembuilder,
          emptyWidget: widget.emptyWidget,
          header: widget.header,
          groupBy: widget.groupBy,
          scrollPadding: widget.scrollPadding,
          style: ListViewStyle.auto,
          maxCrossAxisExtent: widget.maxCrossAxisExtent != null
              ? widget.maxCrossAxisExtent!(MediaQuery.of(context).orientation)
              : 380,
        )

        // ScreenTypeLayout(
        //   mobile: HAFirestoreRealtimePaginatedView.list(
        //     key: ObjectKey(widget.query),
        //     query: widget.query,
        //     limit: widget.limit == null
        //         ? 50
        //         : widget.limit!(DeviceScreenType.Mobile),
        //     builder: widget.itembuilder,
        //     emptyWidget: widget.emptyWidget,
        //     header: widget.header,
        //     groupBy: widget.groupBy,
        //     scrollPadding: widget.scrollPadding,
        //   ),
        //   tablet: HAFirestoreRealtimePaginatedView.grid(
        //     maxCrossAxisExtent: widget.maxCrossAxisExtent != null
        //         ? widget.maxCrossAxisExtent!(MediaQuery.of(context).orientation)
        //         : 380,
        //     query: widget.query,
        //     limit: widget.limit == null
        //         ? 50
        //         : widget.limit!(DeviceScreenType.Mobile),
        //     builder: widget.itembuilder,
        //     header: widget.header,
        //     groupBy: widget.groupBy,
        //     scrollPadding: widget.scrollPadding,
        //     emptyWidget: widget.emptyWidget,
        //   ),
        // ),
        );
  }
}
