import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/model/matching/propose.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/matching_profile/matching_user_detail/matching_user_detail_object.dart';
import 'package:oasis/ui/theme.dart';

import 'cubit/sent_propose_profile_cubit.dart';
import 'cubit/sent_propose_profile_state.dart';

// 내가 보낸 프로포즈의 프로필
class SentProposeProfileScreen extends StatefulWidget {
  final BuildContext mainContext;
  final Propose propose;
  SentProposeProfileScreen({required this.mainContext, required this.propose});
  @override
  _SentProposeProfileScreenState createState() =>
      _SentProposeProfileScreenState();
}

class _SentProposeProfileScreenState extends State<SentProposeProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SentProposeProfileCubit(
        appBloc: widget.mainContext.read<AppBloc>(),
        userRepository: context.read<UserRepository>(),
        propose: widget.propose,
      )..initialize(),
      child: BlocListener<SentProposeProfileCubit, SentProposeProfileState>(
        listener: (context, state) async {},
        child: BlocBuilder<SentProposeProfileCubit, SentProposeProfileState>(
          builder: (context, state) {
            return OverrapBaseScaffold(
              title: "",
              appbarColor: backgroundColor,
              backgroundColor: backgroundColor,
              showAppbarUnderline: false,
              onBack: () {
                Navigator.pop(context);
              },
              body: Container(
                width: double.infinity,
                height: double.infinity,
                child: MatchingUserDetailObject(
                  userProfile: widget.propose.toCustomer,
                  matchingRate: widget.propose.matchingRate ?? 0,
                  compareTendency: state.compareTendency,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
