import 'package:audavis_time_management/domain/repositories/colleague_repository.dart';
import 'package:audavis_time_management/domain/repositories/holiday_repository.dart';
import 'package:audavis_time_management/domain/repositories/leave_repository.dart';
import 'package:audavis_time_management/firebase_options.dart';
import 'package:audavis_time_management/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/avatar_upload_cubit/avatar_upload_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/colleague_cubit/colleague_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/holiday_cubit/holiday_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/leave_management_cubit/leave_management_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/leave_cubit/leave_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/theme_cubit/theme_cubit.dart';
import 'package:audavis_time_management/presentation/blocs/user_leaves_cubit/user_leaves_cubit.dart';
import 'package:audavis_time_management/router.dart';
import 'package:audavis_time_management/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audavis_time_management/service_locator.dart' as di;
import 'package:audavis_time_management/service_locator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initSharedServices();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: AuthCubit()),
        BlocProvider.value(
          value: LeaveManagementCubit(leaveRepository: sl<LeaveRepository>()),
        ),
        BlocProvider.value(
          value: LeaveCubit(leaveRepository: sl<LeaveRepository>()),
        ),
        BlocProvider.value(
          value: ColleaguesCubit(
            colleagueRepository: sl<ColleagueRepository>(),
          ),
        ),
        BlocProvider.value(
          value: HolidayCubit(holidayRepository: sl<HolidayRepository>()),
        ),
        BlocProvider.value(
          value: AvatarUploadCubit(
            colleaguesRepository: sl<ColleagueRepository>(),
          ),
        ),
        BlocProvider.value(
          value: UserLeavesCubit(leaveRepository: sl<LeaveRepository>()),
        ),
        BlocProvider.value(value: ThemeCubit(sl<SharedPreferences>())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final router = AppRouter(
            authCubit: context.read<AuthCubit>(),
          ).router();
          return MaterialApp.router(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('de'), Locale('en')],
            locale: Locale('de', 'DE'),
            scaffoldMessengerKey: Utils.messengerKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: themeState.seedColor,
              ),
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
