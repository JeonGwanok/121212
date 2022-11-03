import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/repository/auth_repository.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/community_repository.dart';
import 'package:oasis/repository/matching_repository.dart';
import 'package:oasis/repository/my_story_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/app_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';


import 'api_client/api_client.dart';
import 'flavor/flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.DEV;

  await Firebase.initializeApp();

  var apiProvider = ApiProvider(baseUrl: F.apiUrl);
  var authRepository = AuthRepository(apiClient: apiProvider);

  var _prefs = await SharedPreferences.getInstance();

  var autoSignIn = _prefs.getBool("autoSignIn");

  if ((autoSignIn ?? false) == false) {
    // 자동로그인 동의하지 않음
    await _prefs.remove("token");
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => authRepository,
        ),
        RepositoryProvider<UserRepository>(
            create: (_) => UserRepository(
                  authRepository: authRepository,
                  apiClient: apiProvider,
                )),
        RepositoryProvider<CommonRepository>(
          create: (_) => CommonRepository(
            apiClient: apiProvider,
          ),
        ),
        RepositoryProvider<MatchingRepository>(
          create: (_) => MatchingRepository(
            authRepository: authRepository,
            apiClient: apiProvider,
          ),
        ),
        RepositoryProvider<MyStoryRepository>(
          create: (_) => MyStoryRepository(
            authRepository: authRepository,
            apiClient: apiProvider,
          ),
        ),
        RepositoryProvider<CommunityRepository>(
          create: (_) => CommunityRepository(
            authRepository: authRepository,
            apiClient: apiProvider,
          ),
        ),
      ],
      child: App(),
    ),
  );
}
