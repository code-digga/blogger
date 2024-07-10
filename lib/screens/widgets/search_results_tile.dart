import 'package:blogger/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchResultsTile extends StatelessWidget {
  const SearchResultsTile({super.key, this.onTap, required this.blog});
  final void Function()? onTap;
  final BlogPost blog;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(14).r),
        padding: const EdgeInsets.all(14).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              blog.subTitle,
              style: TextStyle(fontSize: 18.sp),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
