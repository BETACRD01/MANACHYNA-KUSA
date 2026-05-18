import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme_colors.dart';
import '../auth/profile_screen.dart';
import '../booking/booking_list_screen.dart';
import '../common/chat_screen.dart';
import 'home_inicio/home_inicio_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToSearch({String? initialQuery, String? category}) {
    Navigator.pushNamed(
      context,
      AppRoutes.search,
      arguments: {
        'query': initialQuery,
        'category': category,
      },
    );
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomeInicioTab(onNavigateToSearch: _navigateToSearch),
          const BookingListScreen(),
          const ChatScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: NavigationBar(
              height: 72,
              selectedIndex: _currentIndex,
              backgroundColor: context.appSurface,
              indicatorColor: AppColors.primary.withValues(
                alpha: context.isDarkMode ? 0.22 : 0.14,
              ),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: _onDestinationSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: AppStrings.home,
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month_outlined),
                  selectedIcon: Icon(Icons.calendar_month_rounded),
                  label: AppStrings.bookings,
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline_rounded),
                  selectedIcon: Icon(Icons.chat_bubble_rounded),
                  label: AppStrings.chat,
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: AppStrings.profile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
