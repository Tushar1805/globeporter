// // ignore_for_file: non_constant_identifier_names

// import 'package:hive/hive.dart';
// part 'hive_user_model.g.dart';

// @HiveType(typeId: 0)
// class HiveUserModel {
//   @HiveField(0)
//   final String? fcmToken;
//   @HiveField(1)
//   final String? firstName;
//   @HiveField(2)
//   final String? lastName;
//   @HiveField(3)
//   final String? mobile;
//   @HiveField(4)
//   final String? mobile_no;
//   @HiveField(5)
//   final String? avatar;
//   const HiveUserModel(this.fcmToken, this.firstName, this.lastName, this.mobile, this.mobile_no, this.avatar);

//   Map<String, dynamic> toJson() {
//     return {
//       'fcmToken': fcmToken,
//       'firstName': firstName,
//       'lastName': lastName,
//       'mobile': mobile,
//       'mobile_no': mobile_no,
//       'avatar': avatar,
//     };
//   }

//   factory HiveUserModel.fromJson(Map<String, dynamic> json) {
//     return HiveUserModel(
//       json['fcmToken'] as String?,
//       json['firstName'] as String?,
//       json['lastName'] as String?,
//       json['mobile'] as String?,
//       json['mobile_no'] as String?,
//       json['avatar'] as String?,
//     );
//   }
// }
