part of 'blog_repository.dart';

///This will contain all the queries for the different data
///
///to be retrieved from the endpoint. We want it to only be accessible
///
///from the repository.

String _allBlogsQuery = r'''query fetchAllBlogs {
  allBlogPosts {
    id
    title
    subTitle
    body
    dateCreated
  }
}
 ''';

String _singleBlog = r''' query getBlog($blogId: String!) {
  blogPost(blogId: $blogId) {
    id
    title
    subTitle
    body
    dateCreated
  }
}
''';

String _createBlog =
    r''' mutation createBlogPost($title: String!, $subTitle: String!, $body: String!) {
  createBlog(title: $title, subTitle: $subTitle, body: $body) {
    success
    blogPost {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
}
''';

String _updateBlog =
    r''' mutation updateBlogPost($blogId: String!, $title: String!, $subTitle: String!, $body: String!) {
  updateBlog(blogId: $blogId, title: $title, subTitle: $subTitle, body: $body) {
    success
    blogPost {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
}
''';

String _deleteBlog = r''' mutation deleteBlogPost($blogId: String!) {
  deleteBlog(blogId: $blogId) {
    success
  }
}
''';
