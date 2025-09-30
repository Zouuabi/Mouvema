import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouvema/src/core/utils/string_manager.dart';

import 'package:mouvema/src/presentation/main/home/cubit/home_cubit.dart';
import 'package:mouvema/src/presentation/main/home/cubit/home_state.dart';

import '../../config/routes/routes.dart';

import '../../injector.dart';
import 'home/pages/home_screen.dart';
import 'favorite_loads/pages/favorites_screen.dart';
import 'my_loads/pages/my_loads_screen.dart';
import 'profile/pages/profile_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  final pagecontroller = PageController(initialPage: 0, keepPage: true);
  final pages = const [
    HomeScreen(),
    MyLoadsScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => instance<HomeCubit>(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (BlocProvider.of<HomeCubit>(context).isFirstTime) {
                    Navigator.pushNamed(context, Routes.fillProfil);
                  } else {
                    Navigator.pushReplacementNamed(context, Routes.postLoad);
                  }
                },
                child: const Icon(Icons.add),
              ),
              bottomNavigationBar: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, -1),
                          blurRadius: 2)
                    ]),
                child: GNav(
                    selectedIndex: index,
                    onTabChange: (val) {
                      setState(() {
                        if (val == 3) {
                          if (BlocProvider.of<HomeCubit>(context).isFirstTime) {
                            Navigator.pushNamed(context, Routes.fillProfil);
                          } else {
                            index = val;
                            pagecontroller.jumpToPage(index);
                          }
                        } else {
                          index = val;
                          pagecontroller.jumpToPage(index);
                        }
                      });
                    },
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    curve: Curves.easeOutExpo,
                    duration: const Duration(milliseconds: 300),
                    gap: 8,
                    color: Colors.grey[800],
                    activeColor: Colors.teal,
                    iconSize: 24,
                    tabBackgroundColor: Colors.teal.withValues(alpha: 0.1),
                    tabs: [
                      GButton(
                        icon: Icons.home,
                        text: StringManager.home,
                      ),
                      GButton(
                        icon: Icons.work_history_outlined,
                        text: StringManager.myLoads,
                      ),
                      GButton(
                        icon: Icons.bookmark_border,
                        text: StringManager.favorites,
                      ),
                      GButton(
                        icon: Icons.person_4_outlined,
                        text: StringManager.profile,
                      )
                    ]),
              ),
              body: PageView.builder(
                  controller: pagecontroller,
                  itemCount: 4,
                  onPageChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return pages[index];
                  }),
            );
          },
        ));
  }
}
