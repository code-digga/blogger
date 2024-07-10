import 'package:blogger/blog/cubits/blog_cubit.dart';
import 'package:blogger/blog/cubits/blog_state.dart';
import 'package:blogger/models/blog_model.dart';
import 'package:blogger/screens/widgets/confirmation_dialog.dart';
import 'package:blogger/screens/widgets/custom_input_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../utils/global_variables.dart';

class AddBlogPage extends StatefulWidget {
  const AddBlogPage({super.key, this.blog, this.blogIndex});
  final BlogPost? blog;
  final int? blogIndex;

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  late TextEditingController titleController;
  late TextEditingController subTitleController;
  late TextEditingController bodyController;
  var formKey = GlobalKey<FormState>();
  bool isEditingBlog = false;
  BlogPost? blogToEdit;

  @override
  void initState() {
    super.initState();
    isEditingBlog = widget.blog != null;
    blogToEdit = widget.blog;
    titleController = TextEditingController(text: blogToEdit?.title);
    subTitleController = TextEditingController(text: blogToEdit?.subTitle);
    bodyController = TextEditingController(text: blogToEdit?.body);
  }

  @override
  void dispose() {
    titleController.dispose();
    subTitleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogCubit, BlogState>(
      builder: (context, state) {
        return LoadingOverlay(
            isLoading: state is BlogLoading,
            progressIndicator: const CircularProgressIndicator(
              color: primaryColor,
            ),
            color: Colors.grey.shade300,
            child: PopScope(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: primaryColor,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: secondaryColor,
                      )),
                  title: Text(
                    isEditingBlog ? 'Edit Blog' : 'Create Blog',
                    style: const TextStyle(color: secondaryColor),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(20).r,
                  child: SafeArea(
                      child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                              controller: titleController, fieldHint: 'Title'),
                          SizedBox(
                            height: 30.h,
                          ),
                          CustomTextField(
                              controller: subTitleController,
                              fieldHint: 'Sub Title'),
                          SizedBox(
                            height: 30.h,
                          ),
                          CustomTextField(
                              controller: bodyController,
                              isBodyField: true,
                              fieldHint: 'Body'),
                          SizedBox(
                            height: 70.h,
                          ),
                          SizedBox(
                            width: 200.w,
                            height: 50.h,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14).r)),
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                            primaryColor)),
                                onPressed: () => processRequest(),
                                child: Text(
                                  isEditingBlog ? 'Edit post' : 'Create post',
                                  style: const TextStyle(color: secondaryColor),
                                )),
                          )
                        ],
                      ),
                    ),
                  )),
                ),
              ),
            ));
      },
      listener: (context, state) {
        if (state is BlogLoaded) {
          if (isEditingBlog) {
            Navigator.pop(context, true);
            return;
          }
          Navigator.pop(context);
        } else if (state is BlogError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      listenWhen: (previous, current) {
        return previous.runtimeType != current.runtimeType;
      },
    );
  }

  processRequest() async {
    if (formKey.currentState?.validate() ?? false) {
      var shouldProceed = await showDialog<bool?>(
        context: context,
        builder: (context) =>
            ConfirmationDialog(requestType: isEditingBlog ? 'Edit' : 'Add'),
      );
      if (shouldProceed ?? false) {
        if (isEditingBlog && mounted) {
          var blogUpdate = blogToEdit?.copyWith(
              body: bodyController.text.trim(),
              title: titleController.text.trim(),
              subTitle: subTitleController.text.trim());
          context.read<BlogCubit>().updateBlog(blogUpdate!, widget.blogIndex!);
        } else if (mounted) {
          context.read<BlogCubit>().createBlog(titleController.text.trim(),
              subTitleController.text.trim(), bodyController.text.trim());
        }
      }
    }
  }
}
