import '../../models/blog_model.dart';

sealed class BlogState {}

class BlogIdle extends BlogState {}

class BlogLoading extends BlogState {}

class BlogError extends BlogState {
  final String message;
  BlogError(this.message);
}

class BlogLoaded extends BlogState {
  final List<BlogPost> blogs;
  BlogLoaded(this.blogs);
}

class BlogLoadedSingle extends BlogState {
  final BlogPost singleBlog;
  BlogLoadedSingle(this.singleBlog);
}
