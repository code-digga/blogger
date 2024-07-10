import 'dart:developer';

import 'package:blogger/models/blog_model.dart';
import 'package:blogger/services/data_provider.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';

part 'blog_queries.dart';

class BlogRepository {
  BlogRepository(DataProvider dataProvider) : _dataProvider = dataProvider;
  final DataProvider _dataProvider;

  /// We use `Either` to return a particular data based on our response to display
  ///
  /// to users. If an error occurs, we return the message else we return the blog.
  Future<Either<String, List<BlogPost>>> allBlogs() async {
    var posts = <BlogPost>[];
    try {
      var response = await _dataProvider.query(queryString: _allBlogsQuery);
      if (response?.errorOccured ?? false) {
        return Left(response!.responseMsg);
      }
      List initList = response!.requestedData['allBlogPosts'];
      posts = initList.map((post) => BlogPost.fromMap(post)).toList();
      return Right(posts);
    } catch (e, s) {
      log('===========> all blogs error: $e');
      debugPrintStack(stackTrace: s);
      return Left(e.toString());
    }
  }

  Future<Either<String, BlogPost>> singleBlog(String blogId) async {
    try {
      var response = await _dataProvider
          .query(queryString: _singleBlog, queryVariables: {"blogId": blogId});

      if (response?.errorOccured ?? true) {
        return Left(response?.responseMsg ?? '');
      }
      return Right(BlogPost.fromMap(response!.requestedData['blogPost']));
    } catch (e, s) {
      log('===========> single blog error: $e');
      debugPrintStack(stackTrace: s);
      return Left(e.toString());
    }
  }

  Future<Either<String, BlogPost>> updateBlog(BlogPost blog) async {
    try {
      var response = await _dataProvider.mutate(
          mutString: _updateBlog, mutVariables: blog.toMap());

      if (response?.errorOccured ?? true) {
        return Left(response?.responseMsg ?? '');
      }
      return Right(
          BlogPost.fromMap(response!.requestedData['updateBlog']['blogPost']));
    } catch (e, s) {
      log('===========> update blog error: $e');
      debugPrintStack(stackTrace: s);
      return Left(e.toString());
    }
  }

  Future<Either<String, BlogPost>> createBlog(
      String title, String subTitle, String body) async {
    try {
      var response = await _dataProvider.mutate(
          mutString: _createBlog,
          mutVariables: {"title": title, "subTitle": subTitle, "body": body});

      if (response?.errorOccured ?? true) {
        return Left(response?.responseMsg ?? '');
      }

      return Right(
          BlogPost.fromMap(response!.requestedData['createBlog']['blogPost']));
    } catch (e, s) {
      log('===========> create blog error: $e');
      debugPrintStack(stackTrace: s);
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> deleteBlog(String blogId) async {
    try {
      var response = await _dataProvider
          .mutate(mutString: _deleteBlog, mutVariables: {"blogId": blogId});

      if (response?.errorOccured ?? true) {
        return Left(response?.responseMsg ?? '');
      }
      return Right(response!.requestedData['deleteBlog']['success']);
    } catch (e, s) {
      log('===========> delete blog error: $e');
      debugPrintStack(stackTrace: s);
      return Left(e.toString());
    }
  }
}
