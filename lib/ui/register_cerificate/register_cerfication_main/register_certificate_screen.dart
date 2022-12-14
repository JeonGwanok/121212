import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/bloc/app/app_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/register_cerificate/register_certificate_detail/register_certification_detail_screen.dart';

import '../../theme.dart';
import 'cubit/register_cerficate_cubit.dart';
import 'cubit/register_certificate_state.dart';

enum RegisterCertificateScreenType {
  inSignUp,
  afterSignUp,
}

class RegisterCertificateScreen extends StatefulWidget {
  final Function? onSuccess;
  final Function? onBack;
  final BuildContext mainContext;
  final RegisterCertificateScreenType type;
  RegisterCertificateScreen({
    required this.mainContext,
    this.onBack,
    this.onSuccess,
    this.type = RegisterCertificateScreenType.inSignUp,
  });
  @override
  _RegisterCertificateScreenState createState() =>
      _RegisterCertificateScreenState();
}

class _RegisterCertificateScreenState extends State<RegisterCertificateScreen> {
  CertificateFile? graduate;
  CertificateFile? job;
  CertificateFile? marry;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCertificateCubit(
          userRepository: context.read<UserRepository>(),
          commonRepository: context.read<CommonRepository>(),
          appBloc: widget.mainContext.read<AppBloc>())
        ..initialize(),
      child: BlocListener<RegisterCertificateCubit, RegisterCertificateState>(
        listener: (context, state) async {
          if (state.status == ScreenStatus.success) {
            if (widget.onSuccess != null) {
              widget.onSuccess!();
            }
          }
        },
        child: BlocBuilder<RegisterCertificateCubit, RegisterCertificateState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;
            if ((state.certificate.files ?? [])
                .where((e) => e.typeName == "??????")
                .toList()
                .isNotEmpty) {
              marry = (state.certificate.files ?? [])
                  .where((e) => e.typeName == "??????")
                  .toList()
                  .first;
            }

            if ((state.certificate.files ?? [])
                .where((e) => e.typeName == "??????")
                .toList()
                .isNotEmpty) {
              job = (state.certificate.files ?? [])
                  .where((e) => e.typeName == "??????")
                  .toList()
                  .first;
            }
            if ((state.certificate.files ?? [])
                .where((e) => e.typeName == "??????")
                .toList()
                .isNotEmpty) {
              graduate = (state.certificate.files ?? [])
                  .where((e) => e.typeName == "??????")
                  .toList()
                  .first;
            }

            return BaseScaffold(
              title: "????????????",
              onBack: () {
                if (widget.onBack == null) {
                  Navigator.pop(context);
                } else {
                  widget.onBack!();
                }
              },
              buttons:
                  (widget.type == RegisterCertificateScreenType.afterSignUp)
                      ? []
                      : [
                          BaseScaffoldDefaultButtonScheme(
                            title: "??????",
                            onTap: state.enableButton
                                ? () {
                                    context
                                        .read<RegisterCertificateCubit>()
                                        .update();
                                  }
                                : null,
                          ),
                        ],
              body: Container(
                margin: EdgeInsets.symmetric(
                    vertical: (widget.type ==
                            RegisterCertificateScreenType.afterSignUp)
                        ? 50 * ratio
                        : 20 * ratio),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        if (widget.type !=
                            RegisterCertificateScreenType.afterSignUp)
                          Container(
                            height: 44,
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 77,
                              child: DefaultSmallButton(
                                reverse: true,
                                showShadow: true,
                                onTap: () {
                                  context
                                      .read<RegisterCertificateCubit>()
                                      .update();
                                },
                                title: '????????????',
                              ),
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _iconObject('icons/academic', '?????? ??????'),
                                _iconObject('icons/job', '?????? ??????'),
                                _iconObject('icons/marriage', '?????? ??????'),
                              ]),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            boxShadow: cardShadow,
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '* ?????? 3?????? ?????? ???????????????.',
                                style: header03.copyWith(
                                    color: gray600, height: 1.5),
                              ),
                              Text(
                                """
* ??????????????? ?????? ???????????? ?????? ??? ????????? '??? ??????'?????? ???????????? ??? ????????????.
* ?????? ?????? ?????? ??? ????????? ?????? ????????? ???????????????.??????????????? ?????? 24????????? ????????? ??? ????????????.
* ????????? ???????????? ????????? ????????? ????????? ???????????? ????????????.""",
                                style: body01.copyWith(
                                    fontSize: 11, color: gray600, height: 1.5),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: (widget.type ==
                                    RegisterCertificateScreenType.afterSignUp)
                                ? 20
                                : 5),
                      ],
                    ),
                    Column(
                      children: [
                        DefaultSmallButton(
                          title:
                              "??????????????? ?????? (${state.certificate.graduationStatus.statusTitle})",
                          reverse: true,
                          showShadow: true,
                          onTap: state.certificate.graduationStatus.enableButton
                              ? () async {
                                  Certificate? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterCertificationDetailScreen(
                                        type: "??????",
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    context
                                        .read<RegisterCertificateCubit>()
                                        .updateCertificate(result);
                                  }
                                }
                              : null,
                        ),
                        SizedBox(height: 16 * ratio),
                        DefaultSmallButton(
                          title:
                              "?????? ?????? (${state.certificate.jobStatus.statusTitle})",
                          reverse: true,
                          showShadow: true,
                          onTap: state.certificate.jobStatus.enableButton
                              ? () async {
                                  Certificate? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterCertificationDetailScreen(
                                        type: "??????",
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    context
                                        .read<RegisterCertificateCubit>()
                                        .updateCertificate(result);
                                  }
                                }
                              : null,
                        ),
                        SizedBox(height: 16 * ratio),
                        DefaultSmallButton(
                          title:
                              "????????????????????? ?????? (${state.certificate.marriageStatus.statusTitle})",
                          reverse: true,
                          showShadow: true,
                          onTap: state.certificate.marriageStatus.enableButton
                              ? () async {
                                  Certificate? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterCertificationDetailScreen(
                                        type: "??????",
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    context
                                        .read<RegisterCertificateCubit>()
                                        .updateCertificate(result);
                                  }
                                }
                              : null,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _iconObject(String image, String title) {
    var widthRatio = MediaQuery.of(context).size.width / 360;
    return Column(
      children: [
        CustomIcon(
          path: image,
          width: 78 * widthRatio,
          height: 78 * widthRatio,
        ),
        SizedBox(height: 13),
        Text(
          title,
          style: header03.copyWith(
            fontFamily: "Godo",
          ),
        )
      ],
    );
  }
}
