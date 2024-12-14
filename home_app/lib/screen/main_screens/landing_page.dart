import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/bottom_nav_cubit/bottom_nav_cubit.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/auth.dart'; // Assuming this is the location of your AuthCubit
import 'package:home_app/cubits/user.dart';
import 'package:home_app/screen/layout/shop_coin.dart';
import 'package:home_app/screen/main_screens/chat_screen.dart';
import 'package:home_app/screen/main_screens/home_screen.dart';
import 'package:home_app/screen/main_screens/post_screen.dart';
import 'package:home_app/states/auth_state.dart';
import 'package:home_app/states/user_state.dart';
import 'package:home_app/widget/common/wave_animation.dart';
import 'package:home_app/widget/landing/left_nav_bar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = AppTheme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            // Optional: Handle authentication-related events here.
          },
        ),
      ],
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          bool canPost = false;
          if (userState is UserLoaded) {
            canPost = userState.user.role == "Seller";
          }

          return BlocBuilder<BottomNavCubit, BottomNavState>(
            builder: (context, bottomNavState) {
              List<BottomNavigationBarItem> buildNavItems() {
                return [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  if (canPost)
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.upload_rounded),
                      label: 'Post',
                    ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'Chat',
                  ),
                ];
              }

              List<BottomNavState> availableStates() {
                return [
                  BottomNavState.home,
                  if (canPost) BottomNavState.post,
                  BottomNavState.chat,
                ];
              }

              final navItems = buildNavItems();
              final states = availableStates();

              return Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  elevation: 1,
                  leading: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Icon(
                      Icons.widgets_outlined,
                      color: appTheme.primary,
                    ),
                  ),
                  title: Text(
                    getTitle(bottomNavState),
                    style: appTheme.typography.headlineSmall,
                  ),
                  centerTitle: true,
                  actions: [
                    if (userState is UserLoaded)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.monetization_on_outlined,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              userState.user.coins.toString(),
                              style: appTheme.typography.headlineSmall,
                            ),
                          ],
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 30,
                          height: 20,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
                drawer: const LeftNavBar(),
                body: getCurrentScreen(bottomNavState),
                floatingActionButton: Stack(
                  alignment: Alignment.center,
                  children: [
                    EmittingWave(color: appTheme.primary), // Animated wave
                    FloatingActionButton(
                      backgroundColor: appTheme.primaryBackground,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ShopCoin(),
                          ),
                        );
                      },
                      tooltip: 'Go to Coin Shopping',
                      child: Icon(
                        Icons.shopping_cart,
                        color: appTheme.primary,
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: states.indexOf(bottomNavState),
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: appTheme.primary,
                  unselectedItemColor: Colors.grey,
                  items: navItems,
                  onTap: (index) {
                    context.read<BottomNavCubit>().selectItem(states[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String getTitle(BottomNavState state) {
    switch (state) {
      case BottomNavState.home:
        return 'Home';
      case BottomNavState.post:
        return 'Post';
      case BottomNavState.chat:
        return 'Chat';
      default:
        return 'Home';
    }
  }

  Widget getCurrentScreen(BottomNavState state) {
    switch (state) {
      case BottomNavState.home:
        return const HomeScreen();
      case BottomNavState.post:
        return AddHouseScreen();
      case BottomNavState.chat:
        return const ChatScreen();
      default:
        return const HomeScreen();
    }
  }
}
