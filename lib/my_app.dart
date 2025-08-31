import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:dakeh_service_provider/features/halls/presentation/screens/my_halls_screen.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/home_layout.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/profile_screen.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/screens/reservations_screen.dart';
import 'package:dakeh_service_provider/features/splash/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, });


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()..getCities(),
        ),
        BlocProvider(
          create: (context) => HallsCubit(),
        ),
      ],
      child: MaterialApp(
        home: const AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.transparent),
          child: SplashScreen(),
        ),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Dubai',
          scaffoldBackgroundColor: Colors.grey.shade100,
          colorSchemeSeed: ColorsManager.kPrimaryColor,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle:
                TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            unselectedLabelStyle:
                TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
          ),
        ),
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        routes: {
          'reservation': (context) => const ReservationsScreen(),
          'halls': (context) => const MyHallsScreen(),
          'account': (context) => const ProfileScreen(),
          'home' : (context) => const HomeLayout()
        },
      ),
    );
  }
}
