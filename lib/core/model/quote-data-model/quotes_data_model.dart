import 'package:equatable/equatable.dart';

class Quotes extends Equatable {
  const Quotes({this.quote, this.author, this.id});

  final String? quote;
  final String? author;
  final String? id;

  static const emptyQuoteData = Quotes(author: '', quote: '');

  static Quotes fromFireStore(Map<String, dynamic> data) {
    return Quotes(quote: data['quote'], author: data['author'], id: data['id']);
  }

  static Map<String, dynamic> toFireStore(Quotes quote) {
    return {'quote': quote.quote, 'author': quote.author, 'id': quote.id};
  }

  @override
  List<Object?> get props => [quote, author, id];
}
