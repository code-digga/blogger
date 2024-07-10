import 'package:blogger/bookmarks/cubits/bookmark_state.dart';
import 'package:blogger/bookmarks/repository/bookmark_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/blog_model.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final BookmarkRepo repo;
  BookmarkCubit(this.repo) : super(BookmarksInitial());
  List<BlogPost> bookMarks = [];
  List<String> bookMarkKeys = [];

  void saveBookMark(BlogPost post) async {
    emit(BookmarksLoading());
    var response = await repo.addBookMark(post);
    if (response.isRight) {
      bookMarks.insert(0, post);
      emit(BookmarksLoaded(bookMarks));
    } else {
      emit(BookmarksLoadError(response.left));
    }
  }

  void deleteBookMark(String id, int index) {
    emit(BookmarksLoading());
    var response = repo.removeBookMark(id);
    if (response.isRight) {
      bookMarks.removeAt(index);
      emit(BookmarksLoaded(bookMarks));
    } else {
      emit(BookmarksLoadError(response.left));
    }
  }

  void populateLists() {
    emit(BookmarksLoading());
    var response1 = repo.fetchBookMarks();
    if (response1.isRight) {
      bookMarks = response1.right;
    } else {
      emit(BookmarksLoadError(response1.left));
    }

    var response2 = repo.fetchKeys();
    if (response2.isRight) {
      bookMarkKeys = response2.right;
    }
  }
}
