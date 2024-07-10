import 'package:blogger/blog/cubits/blog_cubit.dart';
import 'package:blogger/screens/widgets/search_results_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    var posts = context.read<BlogCubit>().posts;
    var results = posts
        .where((post) => post.title.contains(query.toLowerCase()))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(20).r,
      child: results.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) => SearchResultsTile(
                  blog: results[index],
                  onTap: () {
                    close(context, (results[index], index));
                  }),
              separatorBuilder: (context, index) => SizedBox(
                    height: 20.h,
                  ),
              itemCount: results.length)
          : const Center(
              child: Text('No matches found'),
            ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var posts = context.read<BlogCubit>().posts;

    return Padding(
      padding: const EdgeInsets.all(20.0).r,
      child: ListView.separated(
          itemBuilder: (context, index) => SearchResultsTile(
              blog: posts[index],
              onTap: () {
                close(context, (posts[index], index));
              }),
          separatorBuilder: (context, index) => SizedBox(
                height: 20.h,
              ),
          itemCount: 10),
    );
  }
}
