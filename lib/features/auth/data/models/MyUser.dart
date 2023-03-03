// class MyUser  {
//   final String? id;
//   final String? name;
//   final String? phone;
//
//   const MyUser(
//       {
//       this.id,
//       this.name,
//       this.phone,
//       });
//
//   // Helper function to convert this MyUser to a Map
//   Map<String, Object?> toFirebaseMap({String? newImage}) {
//     return <String, Object?>{
//       'uid': id,
//       'name': name,
//       'phone': phone,
//     };
//   }
//
//   // Helper function to convert a Map to an instance of MyUser
//   MyUser.fromFirebaseMap(Map<String, Object?> data)
//       : id = data['uid'] as String,
//         name = data['name'] as String,
//         phone = data['phone'] as String;
//
//   // Helper function that updates some properties of this instance,
//   // and returns a new updated instance of MyUser
//   MyUser copyWith({
//     String? id,
//     String? name,
//     String? phone,
//   }) {
//     return MyUser(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       phone: phone ?? this.phone,
//     );
//   }
// }
