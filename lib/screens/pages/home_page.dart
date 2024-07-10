import 'package:blogger/blog/cubits/blog_cubit.dart';
import 'package:blogger/bookmarks/cubits/bookmark_cubit.dart';
import 'package:blogger/screens/pages/blogs_page.dart';
import 'package:blogger/screens/pages/bookmarks_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  var views = [const BlogsPage(), const BookMarks()];

  @override
  void initState() {
    super.initState();
    context.read<BookmarkCubit>().populateLists();
    context.read<BlogCubit>().fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      body: views[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (_index == index) {
            return;
          }
          setState(() {
            _index = index;
          });
        },
        selectedItemColor: const Color(0xff1303fc),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'Bookmarks'),
        ],
      ),
    );
  }
}
