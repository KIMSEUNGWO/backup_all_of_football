
import 'package:flutter/material.dart';

class Pageable {

  int page = 0;
  bool hasMore;
  final int size;

  Pageable({required this.size, this.hasMore = true});

  Pageable nextPage() {
    page++;
    return this;
  }

}

typedef PageFutureCallback<T> = Future<List<T>> Function(Pageable pageable);
typedef PageableViewWidget<T> = Widget Function(T data);