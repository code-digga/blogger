import 'package:blogger/bookmarks/cubits/bookmark_cubit.dart';
import 'package:blogger/bookmarks/repository/bookmark_repo.dart';
import 'package:blogger/screens/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

import 'blog/cubits/blog_cubit.dart';
import 'blog/repository/blog_repository.dart';
import 'services/data_provider.dart';

void main() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('bookmarks');
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (context) => BlogCubit(BlogRepository(DataProvider()))),
      BlocProvider(
          create: (context) =>
              BookmarkCubit(BookmarkRepo(boxName: 'bookmarks')))
    ],
    child: const MyApp(),
  )
      // const MyApp()
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Blogger',
              theme: ThemeData.from(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: const Color(0xff1303fc))),
              themeMode: ThemeMode.light,
              home: const HomePage(),
            ));
  }
}
