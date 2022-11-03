import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/register_page/register_page_screen.dart';
import 'package:oasis/ui/sign/sign_in/sign_screen.dart';
import 'package:oasis/ui/splash_screen.dart';
import '../bloc/app/app_bloc.dart';
import '../bloc/app/app_event.dart';
import '../bloc/app/app_state.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/authentication/authentication_state.dart';
import 'home/home_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationBloc(
        authRepository: context.read<AuthRepository>(),
        userRepository: context.read<UserRepository>(),
      ),
      child: MaterialApp(
        onGenerateTitle: (context) => "oasis",
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ko', 'KR'),
        ],
        theme: ThemeData(fontFamily: 'Nunito'),
        home: _AppView(),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  @override
  State createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.unknown) {
          return SplashScreen();
        }

        if (state.status == AuthenticationStatus.unauthenticated) {
          return SignScreen();
        }

        if (state.status == AuthenticationStatus.authenticated) {
          return BlocProvider<AppBloc>(
            create: (context) => AppBloc(
              userRepository: context.read<UserRepository>(),
            )..add(AppInitialize()),
            child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
              Widget screen = SplashScreen();
              var duration = Duration(milliseconds: 900);

              if (state is AppLoading) {
                var width =
                    ((MediaQuery.of(context).size.height * 1480) / 1688) -
                        MediaQuery.of(context).size.width;
                screen = SplashScreen(
                  enableAnimation: false,
                  width: width,
                );
              }

              if (state is AppUnInitialized) {
                if (!state.completeMyInfo) {
                  screen = RegisterPageScreen(
                    initialPage: 0,
                  );
                } else if (!state.completeExtraInfo) {
                  screen = RegisterPageScreen(
                    initialPage: 1,
                  );
                } else if (!state.completePartnerInfo) {
                  screen = RegisterPageScreen(
                    initialPage: 2,
                  );
                } else if (!state.completeMBTI) {
                  screen = RegisterPageScreen(
                    initialPage: 3,
                  );
                } else if (!state.completeCertificate) {
                  screen = RegisterPageScreen(
                    initialPage: 4,
                  );
                } else if (!state.completeSignUp) {
                  screen = RegisterPageScreen(
                    initialPage: 5,
                  );
                } else {
                  screen = Container();
                }
              }

              if (state is AppLoaded) {
                screen = HomeScreen();
              }

              return AnimatedSwitcher(
                duration: duration,
                child: screen,
              );
            }),
          );
        }

        return SplashScreen();
      },
    );
  }
}
