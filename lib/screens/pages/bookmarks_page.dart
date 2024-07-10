import 'package:blogger/bookmarks/cubits/bookmark_cubit.dart';
import 'package:blogger/bookmarks/cubits/bookmark_state.dart';
import 'package:blogger/screens/widgets/blogs_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/global_variables.dart';

class BookMarks extends StatelessWidget {
  const BookMarks({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Bookmarks',
          style: TextStyle(color: secondaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16).r,
        child: SafeArea(child: BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, state) {
          if (state is BookmarksInitial) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30.h,
                    width: 30.w,
                    child: const CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const Text('Fetching bookmarks')
                ],
              ),
            );
          } else if (state is BookmarksLoaded) {
            var bookMarks = state.bookmarks;
            bookMarks.isNotEmpty
                ? ListView.separated(
                    itemBuilder: (context, index) => BlogTile(
                          blog: bookMarks[index],
                          blogIndex: index,
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 20.h,
                        ),
                    itemCount: bookMarks.length)
                : const Center(child: Text('No bookmarks found'));
          }
          return const Center(child: Text('No bookmarks found'));
        })),
      ),
    );
  }
}
