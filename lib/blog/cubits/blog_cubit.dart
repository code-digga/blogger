import 'package:bloc/bloc.dart';
import 'package:blogger/blog/cubits/blog_state.dart';
import 'package:blogger/blog/repository/blog_repository.dart';

import '../../models/blog_model.dart';

class BlogCubit extends Cubit<BlogState> {
  BlogCubit(BlogRepository repo)
      : _repository = repo,
        super(BlogIdle());

  final BlogRepository _repository;

  List<BlogPost> posts = [];

  void fetchBlogs() async {
    emit(BlogLoading());
    var fetchedPosts = await _repository.allBlogs();
    if (fetchedPosts.isLeft) {
      emit(BlogError(fetchedPosts.left));
    } else {
      posts = fetchedPosts.right;
      emit(BlogLoaded(posts));
    }
  }

  void fetchSingleBlog(String blogId) async {
    emit(BlogLoading());
    var fetchedBlog = await _repository.singleBlog(blogId);
    if (fetchedBlog.isLeft) {
      emit(BlogError(fetchedBlog.left));
    } else {
      emit(BlogLoadedSingle(fetchedBlog.right));
    }
  }

  void updateBlog(BlogPost blog, int blogIndex) async {
    emit(BlogLoading());
    var updatedBlog = await _repository.updateBlog(blog);
    if (updatedBlog.isLeft) {
      emit(BlogError(updatedBlog.left));
    } else {
      posts[blogIndex] = updatedBlog.right;
      emit(BlogLoaded(posts));
    }
  }

  void createBlog(String title, String subTitle, String body) async {
    emit(BlogLoading());
    var newBlog = await _repository.createBlog(title, subTitle, body);
    if (newBlog.isLeft) {
      emit(BlogError(newBlog.left));
    } else {
      posts.insert(0, newBlog.right);
      emit(BlogLoaded(posts));
    }
  }

  void deleteBlog(String blogId, int blogIndex) async {
    emit(BlogLoading());
    var deletedBlog = await _repository.deleteBlog(blogId);
    if (deletedBlog.isLeft) {
      emit(BlogError(deletedBlog.left));
    } else {
      posts.removeAt(blogIndex);
      emit(BlogLoaded(posts));
    }
  }
}
