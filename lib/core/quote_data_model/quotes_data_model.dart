import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Quotes extends Equatable {
  const Quotes({this.quote, this.author});

  final String? quote;
  final String? author;

  static const emptyQuoteData = Quotes(author: '', quote: '');

  factory Quotes.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Quotes(quote: data?['quote'], author: data?['author']);
  }

  @override
  List<Object?> get props => [quote, author];
}
