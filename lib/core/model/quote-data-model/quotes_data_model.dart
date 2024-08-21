import 'package:equatable/equatable.dart';

class Quotes extends Equatable {
  const Quotes({this.quote, this.author, this.adminId, this.docID});

  final String? quote;
  final String? author;
  final String? adminId;
  final String? docID;

  static const emptyQuoteData = Quotes(author: '', quote: '');

  static Quotes fromFireStore(Map<String, dynamic> data) {
    return Quotes(
        quote: data['quote'], author: data['author'], adminId: data['id']);
  }

  // static Map<String, dynamic> toFireStore(Quotes quote) {
  //   return {'quote': quote.quote, 'author': quote.author, 'id': quote.adminId};
  // }

  @override
  List<Object?> get props => [quote, author, adminId, docID];
}
