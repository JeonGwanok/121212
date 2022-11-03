import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/customer/customer.dart';
import 'package:oasis/model/user/image/user_image.dart';
import 'package:oasis/model/user/profile/profile.dart';

class UserProfile extends Equatable {
  final Profile? profile;
  final Customer? customer;
  final UserImage? image;

  const UserProfile({
    this.profile,
    this.customer,
    this.image,
  });

  static const empty = UserProfile();

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profile:
          (json["profile"] != null) ? Profile.fromJson(json["profile"]) : null,
      customer: (json["customer"] != null)
          ? Customer.fromJson(json["customer"])
          : null,
      image: (json["image"] != null) ? UserImage.fromJson(json["image"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "profile": profile != null ? profile!.toJson() : null,
      "customer": customer != null ? customer!.toJson() : null,
      "image": image != null ? image!.toJson() : null,
    };
  }

  UserProfile copyWith({
    Profile? profile,
    Customer? customer,
    UserImage? image,
  }) {
    return UserProfile(
      profile: profile ?? this.profile,
      customer: customer ?? this.customer,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [
        profile,
        customer,
        image,
      ];
}
