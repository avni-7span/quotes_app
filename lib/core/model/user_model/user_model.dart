import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, required this.email, required this.isAdmin});

  static const empty = User(id: '', email: '', isAdmin: false);

  final String? email;
  final String? id;
  final bool? isAdmin;

  Map<String, dynamic> toFireStore() {
    return {
      if (email != null) 'email': email,
      if (id != null) 'id': id,
      if (isAdmin != null) 'isAdmin': isAdmin
    };
  }

  factory User.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return User(
        id: data?['id'], email: data?['email'], isAdmin: data?['isAdmin']);
  }

  @override
  List<Object?> get props => [email, id, isAdmin];
}
