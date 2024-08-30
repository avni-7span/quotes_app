import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.email,
    required this.isAdmin,
    required this.favouriteQuoteIdList,
  });

  static const empty = UserModel(
    id: '',
    email: '',
    isAdmin: false,
    favouriteQuoteIdList: [],
  );

  final String? email;
  final String? id;
  final bool? isAdmin;
  final List<dynamic>? favouriteQuoteIdList;

  factory UserModel.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return UserModel(
      id: data?['id'],
      email: data?['email'],
      isAdmin: data?['isAdmin'],
      favouriteQuoteIdList: data?['favourite_quote_id'],
    );
  }

  @override
  List<Object?> get props => [email, id, isAdmin, favouriteQuoteIdList];
}
