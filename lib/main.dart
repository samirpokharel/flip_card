import 'package:firebase_core/firebase_core.dart';
import 'package:flip_card/blocs/auth/auth_bloc.dart';
import 'package:flip_card/config/custom_route.dart';
import 'package:flip_card/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flip Card',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xff8893F1)
          ),
          initialRoute: '/splash',
          onGenerateRoute: CoustomRoute.onGenerateRoute,
        ),
      ),
    );
  }
}
