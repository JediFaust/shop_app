import 'package:flutter/material.dart';

Widget appBar(
    {String? titleText, Widget? topWidget, Widget? child, bool? float}) {
  return NestedScrollView(
    floatHeaderSlivers: true,
    headerSliverBuilder: (context, innerBoxIsScrolled) => [
      SliverAppBar(
        backgroundColor: Colors.amber,
        floating: float ?? true,
        title: Text(titleText ?? ''),
        centerTitle: true,
      ),
    ],
    body: Column(
      children: [
        topWidget ?? const SizedBox(),
        Expanded(child: child ?? const SizedBox()),
      ],
    ),
  );
}
