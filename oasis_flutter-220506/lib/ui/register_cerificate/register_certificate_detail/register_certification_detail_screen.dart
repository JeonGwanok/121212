import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/model/user/certificate.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/common/base_scaffold.dart';
import 'package:oasis/ui/common/cache_image.dart';
import 'package:oasis/ui/common/custom_icon.dart';
import 'package:oasis/ui/common/default_small_button.dart';
import 'package:oasis/ui/common/illust.dart';
import 'package:oasis/ui/profile_image_update/cubit/profile_image_update_state.dart';
import 'package:oasis/ui/register_cerificate/register_certificate_detail/cubit/register_certification_detail_cubit.dart';

import '../../theme.dart';
import 'cubit/register_certification_detail_state.dart';

class RegisterCertificationDetailScreen extends StatefulWidget {
  final String type;
  RegisterCertificationDetailScreen({required this.type});
  @override
  _RegisterCertificationDetailScreenState createState() =>
      _RegisterCertificationDetailScreenState();
}

class _RegisterCertificationDetailScreenState
    extends State<RegisterCertificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCertificationDetailCubit(
        type: widget.type,
        userRepository: context.read<UserRepository>(),
        commonRepository: context.read<CommonRepository>(),
      )..initialize(),
      child: BlocListener<RegisterCertificationDetailCubit,
          RegisterCertificationDetailState>(
        listener: (context, state) {
          if (state.status == ScreenStatus.success) {
            Navigator.pop(
                context, state.certificate); // pop 되면서 방금 업데이트 된 인증서가 전달 됨
          }
        },
        child: BlocBuilder<RegisterCertificationDetailCubit,
            RegisterCertificationDetailState>(
          builder: (context, state) {
            var ratio = MediaQuery.of(context).size.height / 896;

            var title = "";
            var description = "";
            var title02 = "";
            var description02 = "";

            switch (widget.type) {
              case "직업":
                title = "재직증명서, 명함, 사원증 중에\n한가지를 제출해주세요.";
                description =
                    "소득금액증명을 제출하는 경우도 추가 3개월이 지나면\n새로 인증을 해야합니다.\n\n(서류위조, 허위, 불법행위시에는 제출 본인에게 책임이 있습니다.\n민형사상 법적 책임을 물을 수 있습니다.)\n\n※ 주민번호는 반드시 가린 후 제출해주세요.";
                break;
              case "혼인":
              case "결혼":
                title = "미혼 인증은 1개월 이내의 혼인관계증명서 사진을\n첨부하거나 촬영하여 제출해주시기 바랍니다.";
                description =
                    "1개월 이내의 발급일자가 표시된 선명한 사진을 보내주세요.\n\n(서류위조, 허위, 불법행위시에는 제출 본인에게 책임이 있습니다.\n민형사상 법적 책임을 물을 수 있습니다.)\n\n※ 주민번호는 반드시 가린 후 제출해주세요.";
                title02 = "혼인관계증명서 발급 방법";
                description02 =
                    "1. 인터넷 발급\nPC에서 대한민국 법원 전자가족관계등록시스템 접속 (https://efamily.scourt.go.kr) → 증명서 발급 → 혼인관계증명서\n\n2. 무인발급기\n정부 24 홈페이지(https://www.gov.kr) 접속 → 고객센터 → 서비스 지원 → 무인민원발급안내 → 무인민원발급 설치장소 안내 → 발급기 위치 및 운영시간 확인 후 방문 발급\n\n3. 동사무소 발급\n인근 동사무소 또는 구청 방문 → 신분증 지참 및 수수료 1,000원";
                break;
              case "졸업":
                title = '최종학력의 졸업증명서를 제출해주시기 바랍니다.';
                description =
                    '최종 학교 졸업장 또는 졸업증명서를 첨부하거나\n촬영하여 보내주시 바랍니다.\n\n(서류위조, 허위, 불법행위시에는 제출 본인에게 책임이 있습니다.\n민형사상 법적 책임을 물을 수 있습니다.)\n\n※ 주민번호는 반드시 가린 후 제출해주세요.';
                title02 = '졸업증명서 발급 방법';
                description02 =
                    "1. 온라인 발급\n정부 24 홈페이지(https://www.gov.kr) 접속 → 로그인\n→ 대학교 졸업(예정) 증명 → 학교명 및 학과 입력 →\n수령방법에서 온라인발급(본인출력) 선택 → 프린트 또는 PDF로 저장 \n\n2. 정부24에서 신청 후 주민센터 방문 수령\n정부 24 홈페이지(https://www.gov.kr) 접속 → 로그인\n→ 대학교 졸업(예정) 증명 → 학교명 및 학과 입력 →\n방문 수령기관 입력 → 민원신청하기 클릭 → 민원 처리 완료 문자 또는 홈페이지 확인 → 신청한 주민센터 방문 후 수령 (수수료 1,000원)";
            }

            Widget? _image;

            if (state.file != null) {
              _image = Image.file(
                state.file!,
                fit: BoxFit.cover,
              );
            } else if (state.imageUrl != null) {
              _image = CacheImage(
                url: "http://139.150.75.56/${state.imageUrl!}",
                boxFit: BoxFit.cover,
              );
            }

            return BaseScaffold(
              title: "${widget.type} 인증",
              onLoading: state.status == ScreenStatus.loading,
              onBack: () {
                Navigator.pop(context);
              },
              buttons: [
                BaseScaffoldDefaultButtonScheme(
                  title: "인증요청하기",
                  onTap: state.file != null
                      ? () {
                          context
                              .read<RegisterCertificationDetailCubit>()
                              .save();
                        }
                      : null,
                ),
              ],
              body: Container(
                width: double.infinity,
                // alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: widget.type == "직업"
                    //     ? MainAxisAlignment.start
                    //     : MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40 * ratio),
                        width: 180,
                        child: Column(
                          children: [
                            _image != null
                                ? Container(
                                    width: 180,
                                    height: 180,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: _image,
                                  )
                                : GestureDetector(
                                    onTap: () async {},
                                    child: Container(
                                      width: 180,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: gray200),
                                      ),
                                      alignment: Alignment.center,
                                      child: CustomIcon(
                                        width: 40,
                                        height: 40,
                                        path: "icons/big_plus",
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 6),
                            DefaultSmallButton(
                              title: "서류제출",
                              onTap: () async {
                                var selected =
                                    await _pickImage(ImageSource.gallery);
                                if (selected != null) {
                                  context
                                      .read<RegisterCertificationDetailCubit>()
                                      .selectImage(selected);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Text(
                            title,
                            style: header05,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: body01.copyWith(color: gray600),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      if (widget.type != "직업")
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            boxShadow: cardShadow,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title02,
                                style: header03.copyWith(color: gray600),
                              ),
                              SizedBox(height: 16),
                              Text(
                                description02,
                                style: body01.copyWith(color: gray600),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 30,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _pickImage(ImageSource source) async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 100,
        maxWidth: 500,
      );
      if (image != null) {
        var result = File(image.path);
        return result;
      } else {
        return null;
      }
    } catch (err) {
      print('사진 못가져오는 이슈 $err');
    }
  }
}
