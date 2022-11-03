import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/complete_sign_up.dart';
import 'package:oasis/ui/opti_test/opti_main/opti_test_screen.dart';
import 'package:oasis/ui/register_cerificate/register_cerfication_main/register_certificate_screen.dart';
import 'package:oasis/ui/register_extra_user_profile/register_extra_uer_info_screen.dart';
import 'package:oasis/ui/register_partner/register_partner_info_screen.dart';
import 'package:oasis/ui/register_user_info/register_user_info_screen.dart';
import 'cubit/register_page_cubit.dart';
import 'package:oasis/bloc/app/app_bloc.dart';

class RegisterPageScreen extends StatefulWidget {
  final int initialPage;
  RegisterPageScreen({
    this.initialPage = 0,
  });

  @override
  _RegisterPageScreenState createState() => _RegisterPageScreenState();
}

class _RegisterPageScreenState extends State<RegisterPageScreen> {
  int userInfoInitialPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterPageCubit(
        initialPage: widget.initialPage,
        appBloc: context.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
      )..initialize(),
      child: BlocListener<RegisterPageCubit, RegisterPageState>(
        listener: (context, state) {},
        child: BlocBuilder<RegisterPageCubit, RegisterPageState>(
            builder: (context, state) {
          switch (state.page) {
            case 0:
              return RegisterUserInfoScreen(
                initialPage: userInfoInitialPage,
                onPrev: () {
                  context.read<RegisterPageCubit>().prev();
                },
                onNext: () {
                  context.read<RegisterPageCubit>().next();
                },
              );
            case 1:
              return RegisterExtraUserInfoScreen(
                onPrev: () {
                  userInfoInitialPage = 7;
                  context.read<RegisterPageCubit>().prev();
                },
                onNext: () {
                  context.read<RegisterPageCubit>().next();
                },
              );
            case 2:
              return RegisterPartnerInfoScreen(
                onPrev: () {
                  context.read<RegisterPageCubit>().prev();
                },
                onNext: () {
                  context.read<RegisterPageCubit>().next();
                },
              );

            case 3:
              return OPTITestScreen(
                onPrev: () {
                  context.read<RegisterPageCubit>().prev();
                },
                onNext: () {
                  context.read<RegisterPageCubit>().next();
                },
              );
            case 4:
              return RegisterCertificateScreen(
                mainContext: context,
                onBack: () {
                  context.read<RegisterPageCubit>().prev();
                },
                onSuccess: () {
                  context.read<RegisterPageCubit>().next();
                },
              );
            case 5:
              return CompleteSignUpScreen(
                onPrev: () {
                  context.read<RegisterPageCubit>().prev();
                },
                onNext: () {
                  context.read<RegisterPageCubit>().next();
                },
              );
            case 6:
          }
          return Container();
        }),
      ),
    );
  }
}
