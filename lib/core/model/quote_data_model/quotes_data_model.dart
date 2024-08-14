import 'package:equatable/equatable.dart';

class Quotes extends Equatable {
  const Quotes({this.quote, this.author});

  final String? quote;
  final String? author;

  static const emptyQuoteData = Quotes(author: '', quote: '');

  static Quotes fromFireStore(Map<String, dynamic> data) {
    return Quotes(quote: data['quote'], author: data['author']);
  }

  static Map<String, dynamic> toFireStore(Quotes quote) {
    return {'quote': quote.quote, 'author': quote.author};
  }

  @override
  List<Object?> get props => [quote, author];
}
