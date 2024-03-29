import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/agricultural_society_cubit/agricultural_society_cubit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/employe_cubit/employe_cubit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/farmer_cubit/farmer_cubit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/mony_cubit/mony_cubit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/models/farmer_model.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/screens/splash_page.dart';
import 'package:hessen_app/Association%20application/login%20and%20register/cubits/login_cubit/login_cubit.dart';
import 'package:hessen_app/Association%20application/login%20and%20register/cubits/signup_cubit/signup_cubit.dart';
import 'package:hessen_app/constanc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Association application/home and employe dashboard/cubits/count_price_cubit/count_price_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await Hive.box(Constanc.kFarmersBox).clear();
     
  await Hive.initFlutter();

  Hive.registerAdapter(FarmerModelAdapter());
  await Hive.openBox<FarmerModel>(Constanc.kFarmersBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => LoginCubit(),
        // ),
        // BlocProvider(
        //   create: (context) => GetFarmerCubit(),
        // ),
        // BlocProvider(
        //   create: (context) => CollectMoneyCubit(),
        // ),
        // BlocProvider(
        //   create: (context) => DecreaseMoneyCubit(),
        // ),
        // BlocProvider(
        //   create: (context) => TheSafeCubit(),
        // ),
        // BlocProvider(
        //   create: (context) => GetWithdrawalsCubit(),
        // ),

        BlocProvider(
          create: (context) => FarmerCubit()..getFarmers(),
        ),
        BlocProvider(
          create: (context) => CountPriceCubit(),
        ),
        BlocProvider(
          create: (context) => AgriculturalSocietyCubit(),
        ),
        BlocProvider(
          create: (context) => EmployeCubit()..getEmployeDetails(),
        ),
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => SignUpCubit(),
        ),
        BlocProvider(
          create: (context) => MonyCubit(),
        ),
        BlocProvider(
          create: (context) => AgriculturalSocietyCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar'),
        ],
        locale: const Locale('ar'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Constanc.kColorGreen),
          fontFamily: 'Cairo',
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
