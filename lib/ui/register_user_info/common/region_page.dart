import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oasis/ui/common/default_ignore_field.dart';
import 'package:oasis/ui/common/object_text_default_frame.dart';
import 'package:oasis/ui/common/showBottomSheet.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_cubit.dart';
import 'package:oasis/ui/register_user_info/cubit/register_user_info_state.dart';


class RegisterRegionPage extends StatefulWidget {
  @override
  _RegisterRegionPageState createState() => _RegisterRegionPageState();
}

class _RegisterRegionPageState extends State<RegisterRegionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterUserInfoCubit, RegisterUserInfoState>(
        builder: (context, state) {
      return Container(
        child: Column(
          children: [
            ObjectTextDefaultFrame(
              title: "* 거주지역",
              body: DefaultIgnoreField(
                hintMsg: "지역을 선택해주세요.",
                initialValue: state.city?.name,
                onTap: () async {
                  var city = await showBottomOptionSheet(context,
                      title: "거주지역",
                      minChildSize: 0.8,
                      // maxChildSize: 0.8,
                      items: state.cities,
                      labels: state.cities.map((e) => e.name ?? "").toList());
                  if (city != null) {
                    context
                        .read<RegisterUserInfoCubit>()
                        .enterRegionInfo(city: city);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            ObjectTextDefaultFrame(
              title: "* 거주시군구",
              body: DefaultIgnoreField(
                hintMsg: "시군구를 적어주세요.",
                initialValue: state.country?.name,
                onTap: () async {
                  var country = await showBottomOptionSheet(context,
                      title: "거주시군구",
                      minChildSize: 0.8,
                      // maxChildSize: 0.8,
                      items: state.countries,
                      labels:
                          state.countries.map((e) => e.name ?? "").toList());
                  if (country != null) {
                    context
                        .read<RegisterUserInfoCubit>()
                        .enterRegionInfo(country: country);
                  }
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
