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
                .where((e) => e.typeName == "혼인")
                .toList()
                .isNotEmpty) {
              marry = (state.certificate.files ?? [])
                  .where((e) => e.typeName == "혼인")
                  .toList()
                  .first;
            }

            if ((state.certificate.files ?? [])
                .where((e) => e.typeName == "직업")
                .toList()
                .isNotEmpty) {
              job = (state.certificate.files ?? [])
                  .where((e) => e.typeName == "직업")
                  .toList()
                  .first;
            }
            if ((state.certificate.files ?? [])
                .where((e) => e.typeName == "졸업")
                .toList()
                .isNotEmpty) {
              graduate = (state.certificate.files ?? [])
                  .where((e) => e.typeName == "졸업")
                  .toList()
                  .first;
            }

            return BaseScaffold(
              title: "서류인증",
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
                            title: "다음",
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
                                title: '건너뛰기',
                              ),
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _iconObject('icons/academic', '학력 인증'),
                                _iconObject('icons/job', '직업 인증'),
                                _iconObject('icons/marriage', '미혼 인증'),
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
                                '* 인증 3종은 필수 제출입니다.',
                                style: header03.copyWith(
                                    color: gray600, height: 1.5),
                              ),
                              Text(
                                """
* 건너뛰기로 우선 회원가입 완료 후 추후에 '내 정보'에서 인증하실 수 있습니다.
* 인증 서류 제출 후 관리자 최종 승인이 필요합니다.승인까지는 최대 24시간이 소요될 수 있습니다.
* 인증이 완료되지 않으면 이상형 매칭이 진행되지 않습니다.""",
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
                              "졸업증명서 등록 (${state.certificate.graduationStatus.statusTitle})",
                          reverse: true,
                          showShadow: true,
                          onTap: state.certificate.graduationStatus.enableButton
                              ? () async {
                                  Certificate? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterCertificationDetailScreen(
                                        type: "졸업",
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
                              "직업 인증 (${state.certificate.jobStatus.statusTitle})",
                          reverse: true,
                          showShadow: true,
                          onTap: state.certificate.jobStatus.enableButton
                              ? () async {
                                  Certificate? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterCertificationDetailScreen(
                                        type: "직업",
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
                              "혼인관계증명서 등록 (${state.certificate.marriageStatus.statusTitle})",
                          reverse: true,
                          showShadow: true,
                          onTap: state.certificate.marriageStatus.enableButton
                              ? () async {
                                  Certificate? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterCertificationDetailScreen(
                                        type: "혼인",
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
