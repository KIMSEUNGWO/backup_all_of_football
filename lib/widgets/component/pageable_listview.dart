

import 'package:groundjp/component/pageable.dart';
import 'package:groundjp/domain/match/match_simp.dart';
import 'package:flutter/cupertino.dart';

class PageableListView<T> extends StatefulWidget {

  final int size;
  final IndexedWidgetBuilder separatorBuilder;
  final PageFutureCallback<T> future;
  final PageableViewWidget<T> builder;

  const PageableListView({super.key, required this.size, required this.separatorBuilder, required this.future, required this.builder});

  @override
  State<PageableListView<T>> createState() => _PageableListViewState<T>();

  static _PageableSliverListView<T> sliver<T>({required int size, required IndexedWidgetBuilder separatorBuilder, required PageFutureCallback<T> future, required PageableViewWidget<T> builder}) {
    return _PageableSliverListView(size: size, separatorBuilder: separatorBuilder, future: future, builder: builder);
  }
}

class _PageableListViewState<T> extends State<PageableListView<T>> {

  final List<T> _items = [];
  late Pageable _pageable;
  bool _loading = true;

  _fetch() async {
    List<T> moreData = await widget.future(_pageable.nextPage());
    setState(() {
      _pageable.hasMore = _pageable.size <= moreData.length;
      _items.addAll(moreData);
      _loading = false;
    });
  }
  _initData() async {
    List<T> data = await widget.future(_pageable);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _pageable.hasMore = _pageable.size <= data.length;
        _items.addAll(data);
        _loading = false;
      });
    },);
  }

  _initPageable() {
    _pageable = Pageable(
      size: widget.size,
    );
  }

  @override
  void initState() {
    _initPageable();
    _initData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CupertinoActivityIndicator(),);
    return ListView.separated(
      separatorBuilder: widget.separatorBuilder,
      itemCount: _items.length + (_pageable.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (_items.isNotEmpty && index == _items.length && !_loading && _pageable.hasMore) {
          _fetch();
          return const Center(child: CupertinoActivityIndicator(),);
        }
        return widget.builder(_items[index]);
      },
    );
  }
}

class _PageableSliverListView<T> extends StatefulWidget {

  final int size;
  final IndexedWidgetBuilder separatorBuilder;
  final PageFutureCallback<T> future;
  final PageableViewWidget<T> builder;

  const _PageableSliverListView({super.key, required this.size, required this.separatorBuilder, required this.future, required this.builder});

  @override
  State<_PageableSliverListView<T>> createState() => _PageableSliverListViewState<T>();
}

class _PageableSliverListViewState<T> extends State<_PageableSliverListView<T>> {

  final List<T> _items = [];
  late Pageable _pageable;
  bool _loading = true;

  _fetch() async {
    List<T> moreData = await widget.future(_pageable.nextPage());
    setState(() {
      _pageable.hasMore = _pageable.size <= moreData.length;
      _items.addAll(moreData);
      _loading = false;
    });
  }
  _initData() async {
    List<T> data = await widget.future(_pageable);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _pageable.hasMore = _pageable.size <= data.length;
        _items.addAll(data);
        _loading = false;
      });
    },);
  }

  _initPageable() {
    _pageable = Pageable(
      size: widget.size,
    );
  }

  @override
  void initState() {
    _initPageable();
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SliverToBoxAdapter(child: Center(child: CupertinoActivityIndicator(),));
    return SliverList.separated(
      separatorBuilder: widget.separatorBuilder,
      itemCount: _items.length + (_pageable.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (_items.isNotEmpty && index == _items.length && !_loading && _pageable.hasMore) {
          _fetch();
          return const Center(child: CupertinoActivityIndicator(),);
        }
        return widget.builder(_items[index]);
      },
    );
  }
}



