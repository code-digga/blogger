import 'package:blogger/blog/cubits/blog_cubit.dart';
import 'package:blogger/blog/cubits/blog_state.dart';
import 'package:blogger/screens/pages/add_blog_page.dart';
import 'package:blogger/screens/pages/view_blog_page.dart';
import 'package:blogger/screens/widgets/blogs_tile.dart';
import 'package:blogger/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_search.dart';

class BlogsPage extends StatelessWidget {
  const BlogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Blogs',
          style: TextStyle(color: secondaryColor),
        ),
        elevation: 0.h,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: IconButton(
                onPressed: () async {
                  var result = await showSearch(
                      context: context, delegate: CustomSearchDelegate());
                  if (result != null && context.mounted) {
                    var (post, index) = result;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewBlog(blog: post, index: index),
                        ));
                  }
                },
                icon: const Icon(
                  Icons.search,
                  color: secondaryColor,
                )),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddBlogPage(),
              )),
          child: const Icon(
            Icons.add,
            color: secondaryColor,
          )),
      body: Padding(
        padding: const EdgeInsets.all(16).r,
        child: SafeArea(child: BlocBuilder<BlogCubit, BlogState>(
          builder: (context, state) {
            if (state is BlogLoading) {
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
                    const Text('Fetching blogs')
                  ],
                ),
              );
            } else if (state is BlogLoaded) {
              var blogs = state.blogs;
              return blogs.isNotEmpty
                  ? ListView.separated(
                      itemBuilder: (context, index) {
                        var blog = blogs[index];

                        return BlogTile(
                          blog: blog,
                          blogIndex: index,
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(
                            height: 10.h,
                          ),
                      itemCount: blogs.length)
                  : const Center(child: Text('No blogs found'));
            }
            return const Center(child: Text('No blogs found'));
          },
        )),
      ),
    );
  }
}
