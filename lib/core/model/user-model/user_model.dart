import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(
      {required this.id,
      required this.email,
      required this.isAdmin,
      required this.favouriteQuoteIdList});

  static const empty =
      User(id: '', email: '', isAdmin: false, favouriteQuoteIdList: []);

  final String? email;
  final String? id;
  final bool? isAdmin;
  final List<dynamic>? favouriteQuoteIdList;

  factory User.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return User(
        id: data?['id'],
        email: data?['email'],
        isAdmin: data?['isAdmin'],
        favouriteQuoteIdList: data?['favourite_quote_id']);
  }

  @override
  List<Object?> get props => [email, id, isAdmin, favouriteQuoteIdList];
}
