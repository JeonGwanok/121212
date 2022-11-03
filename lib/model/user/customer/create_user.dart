import 'package:equatable/equatable.dart';
import 'package:oasis/model/user/customer/customer.dart';
import 'package:oasis/model/user/customer/signInfo.dart';

class CreateUser extends Equatable {
  final SignInfo? user;
  final Customer? customer;

  CreateUser({this.user, this.customer});

  static const empty = SignInfo();

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     user: (json["user"] != null) ? SignInfo.fromJson(json["user"]) : null,
  //     customer: (json["customer"] != null)
  //         ? Customer.fromJson(json["customer"])
  //         : null,
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      "user": user != null ? user!.toJson() : null,
      "customer": customer != null ? customer!.toJson() : null,
    };
  }

  CreateUser copyWith({
    SignInfo? user,
    Customer? customer,
  }) {
    return CreateUser(
      user: user ?? this.user,
      customer: customer ?? this.customer,
    );
  }

  @override
  List<Object?> get props => [user, customer];
}
