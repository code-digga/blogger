import 'dart:developer';

import 'package:blogger/services/db_provider.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

import '../../models/blog_model.dart';

class BookmarkRepo {
  final DbProvider _dbStore;

  BookmarkRepo({required String boxName}) : _dbStore = DbProvider(boxName);

  Future<Either<String, bool>> addBookMark(BlogPost post) async {
    var key = post.id;
    var value = post.toJson();

    try {
      await _dbStore.saveBookMark(key, value);
      return const Right(true);
    } catch (e, s) {
      log('===========> add bookmark error: $e');
      debugPrintStack(stackTrace: s);
      return Left(e.toString());
    }
  }

  Either<String, bool> removeBookMark(String postId) {
    var key = postId;
    try {
      _dbStore.removeBookMark(key);
      return const Right(true);
    } catch (e, s) {
      log('===========> remove bookmark error: $e');
      debugPrintStack(stackTrace: s);
      return Left(e.toString());
    }
  }

  Either<String, List<BlogPost>> fetchBookMarks() {
    try {
      dynamic posts = _dbStore.allBookMarks();
      if (posts != null) {
        List<BlogPost> bookMarks =
            posts.map((post) => BlogPost.fromJson(post)).toList();
        return Right(bookMarks);
      }
      return const Right([]);
    } catch (e, s) {
      log('===========> all bookmarks error: $e');
      debugPrintStack(stackTrace: s);
      return Left(e.toString());
    }
  }

  Either<String, List<String>> fetchKeys() {
    try {
      dynamic boxKeys = _dbStore.allKeys();
      if (boxKeys != null) {
        List<String> keys = boxKeys.map((post) => post.toString()).toList();
        return Right(keys);
      }
      return const Right([]);
    } catch (e, s) {
      log('===========> all keys error: $e');
      debugPrintStack(stackTrace: s);
      return Left(e.toString());
    }
  }
}
