import 'package:blogger/blog/cubits/blog_cubit.dart';
import 'package:blogger/blog/cubits/blog_state.dart';
import 'package:blogger/models/blog_model.dart';
import 'package:blogger/screens/pages/add_blog_page.dart';
import 'package:blogger/screens/widgets/confirmation_dialog.dart';
import 'package:blogger/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ViewBlog extends StatelessWidget {
  const ViewBlog({super.key, required this.blog, required this.index});
  final BlogPost blog;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogCubit, BlogState>(
      listener: (context, state) {
        if (state is BlogLoaded) {
          Navigator.pop(context);
        } else if (state is BlogError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      listenWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, state) => LoadingOverlay(
        isLoading: state is BlogLoading,
        progressIndicator: const CircularProgressIndicator(
          color: primaryColor,
        ),
        color: Colors.grey.shade300,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.h,
            backgroundColor: primaryColor,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    blog.subTitle,
                    style: TextStyle(fontSize: 16.sp),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    blog.body,
                    style: TextStyle(fontSize: 16.sp),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () async {
                              var updatedBlog = await Navigator.push<bool?>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddBlogPage(
                                      blog: blog,
                                      blogIndex: index,
                                    ),
                                  ));

                              if (updatedBlog ?? false) {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 30,
                              color: primaryColor,
                            )),
                        IconButton(
                            onPressed: () async {
                              var shouldProceed = await showDialog<bool?>(
                                context: context,
                                builder: (context) => const ConfirmationDialog(
                                    requestType: 'Delete'),
                              );
                              if (shouldProceed ?? false) {
                                if (context.mounted) {
                                  context
                                      .read<BlogCubit>()
                                      .deleteBlog(blog.id, index);
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.red,
                              size: 30,
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
