import 'package:blogger/bookmarks/cubits/bookmark_cubit.dart';
import 'package:blogger/bookmarks/cubits/bookmark_state.dart';
import 'package:blogger/models/blog_model.dart';
import 'package:blogger/screens/pages/view_blog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogTile extends StatelessWidget {
  const BlogTile({
    super.key,
    required this.blog,
    required this.blogIndex,
  });
  final BlogPost blog;
  final int blogIndex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewBlog(
                    blog: blog,
                    index: blogIndex,
                  ))),
      child: Container(
        padding: const EdgeInsets.all(16).r,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(14).r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              blog.subTitle,
              style: TextStyle(fontSize: 16.sp),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    blog.formatDate(),
                    style: TextStyle(fontSize: 12.sp),
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                BlocBuilder<BookmarkCubit, BookmarkState>(
                    buildWhen: (previous, current) {
                  return previous.runtimeType != current.runtimeType;
                }, builder: (context, state) {
                  var keys = context.read<BookmarkCubit>().bookMarkKeys;
                  var isBookMarked = keys.contains(blog.id);
                  return IconButton(
                      onPressed: () {
                        if (isBookMarked) {
                          context
                              .read<BookmarkCubit>()
                              .deleteBookMark(blog.id, blogIndex);
                        } else {
                          context.read<BookmarkCubit>().saveBookMark(blog);
                        }
                      },
                      icon: Icon(
                        Icons.bookmark,
                        color: isBookMarked ? Colors.blue : null,
                      ));
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
