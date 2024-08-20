import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? username;
  String? password;
  String? fullName;
  String? politicalName;
  String? post;
  String? cgpa;
  String? about;
  String? whyPost;
  String? imageUrl;
  int? voteCount;
  String? emergencyContact;
  String? gender;
  String? status;
  String? yearOfBirth;
  String? level;
  String? email;
  String? image;
  String? department;
  String? deviceToken;
  OffPeriod? offPeriod;
  CurrentShift? currentShift;
  bool? verified;  // Add the verified field

  UserModel({
    this.username,
    this.password,
    this.fullName,
    this.politicalName,
    this.post,
    this.cgpa,
    this.about,
    this.whyPost,
    this.imageUrl,
    this.voteCount,
    this.emergencyContact,
    this.gender,
    this.status,
    this.yearOfBirth,
    this.level,
    this.email,
    this.image,
    this.department,
    this.deviceToken,
    this.offPeriod,
    this.currentShift,
    this.verified,  // Initialize the verified field
  });

  UserModel copyWith({
    String? username,
    String? password,
    String? fullName,
    String? politicalName,
    String? post,
    String? cgpa,
    String? about,
    String? whyPost,
    String? imageUrl,
    int? voteCount,
    String? emergencyContact,
    String? gender,
    String? status,
    String? yearOfBirth,
    String? level,
    String? email,
    String? image,
    String? department,
    String? deviceToken,
    OffPeriod? offPeriod,
    CurrentShift? currentShift,
    bool? verified,  // Add the verified field in copyWith method
  }) =>
      UserModel(
        username: username ?? this.username,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
        politicalName: politicalName ?? this.politicalName,
        post: post ?? this.post,
        cgpa: cgpa ?? this.cgpa,
        about: about ?? this.about,
        whyPost: whyPost ?? this.whyPost,
        imageUrl: imageUrl ?? this.imageUrl,
        voteCount: voteCount ?? this.voteCount,
        emergencyContact: emergencyContact ?? this.emergencyContact,
        gender: gender ?? this.gender,
        status: status ?? this.status,
        yearOfBirth: yearOfBirth ?? this.yearOfBirth,
        level: level ?? this.level,
        email: email ?? this.email,
        image: image ?? this.image,
        department: department ?? this.department,
        deviceToken: deviceToken ?? this.deviceToken,
        offPeriod: offPeriod ?? this.offPeriod,
        currentShift: currentShift ?? this.currentShift,
        verified: verified ?? this.verified,  // Update the verified field
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    password: json["password"],
    fullName: json["fullName"],
    politicalName: json["politicalName"],
    post: json["post"],
    cgpa: json["cgpa"],
    about: json["about"],
    whyPost: json["whyPost"],
    imageUrl: json["imageUrl"],
    voteCount: json["voteCount"] ?? 0,
    emergencyContact: json["emergencyContact"],
    gender: json["gender"],
    status: json["status"],
    yearOfBirth: json["year_of_birth"],
    level: json["level"],
    email: json["email"],
    image: json["image"],
    department: json["department"],
    deviceToken: json["device_token"],
    offPeriod: json["off_period"] == null
        ? null
        : OffPeriod.fromJson(json["off_period"]),
    currentShift: json["current_shift"] == null
        ? null
        : CurrentShift.fromJson(json["current_shift"]),
    verified: json["verified"],  // Parse the verified field from JSON
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "fullName": fullName,
    "politicalName": politicalName,
    "post": post,
    "cgpa": cgpa,
    "about": about,
    "whyPost": whyPost,
    "imageUrl": imageUrl,
    "voteCount": voteCount,
    "emergencyContact": emergencyContact,
    "gender": gender,
    "status": status,
    "year_of_birth": yearOfBirth,
    "level": level,
    "email": email,
    "image": image,
    "department": department,
    "device_token": deviceToken,
    "off_period": offPeriod?.toJson(),
    "current_shift": currentShift?.toJson(),
    "verified": verified,  // Serialize the verified field to JSON
  };
}

class CurrentShift {
  DateTime? start;
  DateTime? end;
  String? shift;

  CurrentShift({
    this.start,
    this.end,
    this.shift,
  });

  CurrentShift copyWith({
    DateTime? start,
    DateTime? end,
    String? shift,
  }) =>
      CurrentShift(
        start: start ?? this.start,
        end: end ?? this.end,
        shift: shift ?? this.shift,
      );

  factory CurrentShift.fromJson(Map<String, dynamic> json) => CurrentShift(
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
    shift: json["shift"],
  );

  Map<String, dynamic> toJson() => {
    "start": start?.toIso8601String(),
    "end": end?.toIso8601String(),
    "shift": shift,
  };
}

class OffPeriod {
  DateTime? start;
  DateTime? end;

  OffPeriod({
    this.start,
    this.end,
  });

  OffPeriod copyWith({
    DateTime? start,
    DateTime? end,
  }) =>
      OffPeriod(
        start: start ?? this.start,
        end: end ?? this.end,
      );

  factory OffPeriod.fromJson(Map<String, dynamic> json) => OffPeriod(
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
  );

  Map<String, dynamic> toJson() => {
    "start": start?.toIso8601String(),
    "end": end?.toIso8601String(),
  };
}
