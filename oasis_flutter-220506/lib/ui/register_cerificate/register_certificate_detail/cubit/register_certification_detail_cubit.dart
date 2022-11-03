import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/enum/screen_status.dart';
import 'package:oasis/repository/common_repository.dart';
import 'package:oasis/repository/user_repository.dart';
import 'package:oasis/ui/register_cerificate/register_certificate_detail/cubit/register_certification_detail_state.dart';

class RegisterCertificationDetailCubit
    extends Cubit<RegisterCertificationDetailState> {
  final String type;
  final UserRepository userRepository;
  final CommonRepository commonRepository;

  RegisterCertificationDetailCubit({
    required this.type,
    required this.userRepository,
    required this.commonRepository,
  }) : super(RegisterCertificationDetailState());

  initialize() async {
    var user = await userRepository.getUser();
    var certificate =
        await userRepository.getCertificate("${user.customer!.id}");
    String? url;

    if ((certificate.files ?? [])
        .where((e) => e.typeName == type)
        .toList()
        .isNotEmpty) {
      url = (certificate.files ?? [])
          .where((e) => e.typeName == type)
          .toList()
          .first
          .certificateFile;
    }

    emit(state.copyWith(
        userProfile: user, certificate: certificate, imageUrl: url));
  }

  selectImage(File file) {
    emit(state.copyWith(file: file));
  }

  save() async {
    emit(state.copyWith(status: ScreenStatus.loading));
    try {
      var certificate = await userRepository.uploadCertificate(
          type, "${state.userProfile.customer!.id}", state.file!);
      emit(state.copyWith(
          certificate: certificate, status: ScreenStatus.success));
    } catch (err) {
      print('실패입니다. $err');
    }
  }
}


// String fileName = "$number\_${DateTime.now().millisecondsSinceEpoch}.$extension";
// AwsS3PluginFlutter awsS3 = AwsS3PluginFlutter(
//   awsFolderPath: 'brand/testorder',
//   fileNameWithExt: fileName,
//   region: Regions.AP_NORTHEAST_2,
//   bucketName: 'nmodelin20',
//   AWSAccess: "AKIAQNMRVTJV25AMTQ42",
//   AWSSecret: "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",
//   file: file,
// );
