// class AppUser {
//   String? id;
//   String? firstName;
//   String? surName;
//   String? email;
//   String? password;
//   String? phoneNumber;
//   String? profileImage;
//   String? location;

//   AppUser({
//     this.id,
//     this.firstName,
//     this.surName,
//     this.email,
//     this.password,
//     this.phoneNumber,

//     this.location,
//     this.profileImage,
//   });

//   factory AppUser.fromJson(Map<String, dynamic> json) {
//     return AppUser(
//       id: json['id'],
//       firstName: json['name'],
//       surName: json['surname'],
//       email: json['email'],
//       password: json['password'],
//       phoneNumber: json['phoneNumber'],
//       location: json['location'],
//       profileImage: json['profileImage'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'firstName': firstName,
//       'surName': surName,
//       'email': email,
//       'password': password,
//       'location': location,
//       'phoneNumber': phoneNumber,
//       'profileImage': profileImage,
//     };
//   }
// }
