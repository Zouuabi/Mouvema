/// User types enum
enum UserType {
  shipper,
  driver;

  String get displayName {
    switch (this) {
      case UserType.shipper:
        return 'Shipper';
      case UserType.driver:
        return 'Driver';
    }
  }

  String get description {
    switch (this) {
      case UserType.shipper:
        return 'I need to ship goods';
      case UserType.driver:
        return 'I transport goods';
    }
  }

  static UserType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'shipper':
        return UserType.shipper;
      case 'driver':
        return UserType.driver;
      default:
        return UserType.shipper;
    }
  }
}

/// Enhanced user model with additional fields
class MyUser {
  final String uid;
  final String username;
  final String email;
  final String birdhdate;
  final String tel;
  final List<dynamic> favoriteLoads;
  final String image;
  final UserType userType;

  const MyUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.birdhdate,
    required this.tel,
    required this.favoriteLoads,
    required this.image,
    required this.userType,
  });

  factory MyUser.fromfirestore(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      birdhdate: map['birthdate'] ?? '',
      tel: map['tel'] ?? '',
      favoriteLoads: map['favoriteLoads'] ?? [],
      image: map['image'] ?? '',
      userType: UserType.fromString(map['userType'] ?? 'shipper'),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'username': username,
        'email': email,
        'birthdate': birdhdate,
        'tel': tel,
        'favoriteLoads': favoriteLoads,
        'image': image,
        'userType': userType.name,
      };
}
