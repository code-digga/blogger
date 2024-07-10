import '../../models/blog_model.dart';

sealed class BookmarkState {}

class BookmarksInitial extends BookmarkState {}

class BookmarksLoading extends BookmarkState {}

class BookmarksLoaded extends BookmarkState {
  final List<BlogPost> bookmarks;
  BookmarksLoaded(this.bookmarks);
}

class BookmarksLoadedSingle extends BookmarkState {
  final BlogPost singlePost;
  BookmarksLoadedSingle(this.singlePost);
}

class BookmarksLoadError extends BookmarkState {
  final String message;
  BookmarksLoadError(this.message);
}
